require 'brigade/models'
require 'brigade/reddit_api'
require 'brigade/subreddit_crawler'
require 'brigade/link_crawler'
require 'brigade/link_manager'
require 'uri'

class Brigade
  include Celluloid::Logger  

  def initialize(config)
    @config = config
    ActiveRecord::Base.establish_connection(@config['database'])

    session = RedditAPI.auth(@config['reddit']['username'], @config['reddit']['password'])


    @supervisor = Celluloid::SupervisionGroup.new        
    @supervisor.pool(RedditAPI, size: 3, args: [session], as: :reddit_api)
    @supervisor.pool(LinkCrawler, size: 3, as: :link_crawler)
  end

  def run
    info "Running..."

    Subreddit.select(:id).each do |sr|
      @supervisor.supervise(SubredditCrawler, [sr.id, @api])
    end

    @supervisor.supervise(LinkManager)
  end

end
