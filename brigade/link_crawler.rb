class LinkCrawler
  include Celluloid  
  include Celluloid::Logger

  LOCK_TIMEOUT_MINS = 10

  def crawl(link_id)

    total_score = nil
    locked = Link.update_all "locked_at = NOW()", ["id = ? AND (locked_at IS NULL or locked_at >= ?)", link_id, LOCK_TIMEOUT_MINS.minutes.ago]
    if locked == 1
      info ">>>> crawling: #{link_id}"      
      link = Link.where(id: link_id).first
      url = link.url

      if url =~ /\/comments\/([a-z0-9]+)\//
        thing_id = Regexp.last_match[1]
        thing_id = Regexp.last_match[1] if url =~ /\/([a-z0-9]+)\/?$/

        reddit_api = Celluloid::Actor[:reddit_api]

        thing = reddit_api.get_thing(url.sub(/\/$/, ''), thing_id)
        if thing.present?
          score = thing['score'] || (thing['ups'] - thing['downs'])
          
          LinkScore.create(link_id: link_id, ups: thing['ups'], downs: thing['downs'], score: score)
        end
      end
    end

  ensure    
    Link.update_all(['locked_at = NULL, last_crawled_at = now(), earliest_score = COALESCE(earliest_score, :score), latest_score = :score', score: score], ['id = ?', link_id]) if locked == 1
  end

end