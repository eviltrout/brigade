class LinkManager
  include Celluloid  
  include Celluloid::Logger

  def initialize
    work!
  end

  def work
    loop do

      link = Link.select(:id)
              .where("locked_at IS NULL AND (last_crawled_at IS NULL OR last_crawled_at <= ?)", 5.minutes.ago)
              .order("last_crawled_at DESC, RANDOM()")
              .first

      if link.present?
        link_crawler = Celluloid::Actor[:link_crawler]
        link_crawler.crawl!(link.id)
      end

      sleep rand
    end
  end

end