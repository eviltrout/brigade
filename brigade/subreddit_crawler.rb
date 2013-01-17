class SubredditCrawler
  include Celluloid  
  include Celluloid::Logger

  def initialize(subreddit_id)
    @subreddit = Subreddit.where(id: subreddit_id).first
    work!
  end

  def crawl_submissions
    info "Crawling Submissions in #{@subreddit.name}..."

    reddit_api = Celluloid::Actor[:reddit_api]
    new_submissions = reddit_api.new_submissions(@subreddit.name)

    Submission.transaction do
      new_submissions.each do |sub|
        submission = @subreddit.submissions.create(reddit_id: sub['id'],
                                                   title: sub['title'],                                     
                                                   permalink: sub['permalink'],
                                                   submission_date: Time.at(sub['created_utc'])) 

        unless submission.new_record?


          if sub['is_self']
            # On a self post, extract all the links from within
            html = sub['selftext_html']
            html.gsub!(/&lt;/, '<')
            html.gsub!(/&rt;/, '>')
            urls = URI.extract(html)
          else
            urls = [sub['url']]
          end
      

          if urls.present?
            urls.uniq.each do |u|
              if u =~ /http(s)?:/ and u =~ /\/comments\//
                begin
                  uri = URI(u)
                  if uri.host =~ /^(www\.)?reddit\.com/
                    # We only care about links to reddit from a sub

                    u.gsub!(/\?context\=[0-9]+$/, '')
                    submission.links.create(url: u)
                  end
                rescue URI::InvalidURIError
                  # In case the URL is weird for some reason.
                end

              end
            end
          end
        end
      end

      @subreddit.reload
      @subreddit.last_crawled_at = Time.now
      @subreddit.save!
    end    
  end

  def work
    last_crawled_links = nil
    loop do
      # Crawl 'new' links every 5 minutes or so
      crawl_submissions if @subreddit.last_crawled_at.nil? or @subreddit.last_crawled_at < 5.minutes.ago
      sleep 1
    end
  end

end