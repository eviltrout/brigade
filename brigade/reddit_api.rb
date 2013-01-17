class RedditAPI
  include Celluloid
  include Celluloid::Logger

  def self.base_url
    "http://www.reddit.com/"
  end

  def initialize(session)
    @session = session
  end

  def get(url) 
    HTTParty.get(url, headers: {"Cookie" => @session}).body
  end

  def new_submissions(subreddit_name)
    new_listings = JSON.parse(get("#{RedditAPI.base_url}/r/#{subreddit_name}.json"))
    children = new_listings['data']['children']
    children.collect! {|c| c['data']}
    children
  end

  def get_thing(url, thing_id)
    things = JSON.parse(get(url + ".json"), max_nesting: 1000)
    things.each do |t|
      if t['data'].present? and t['data']['children'].present?
        t['data']['children'].each do |c|
          if c['data'].present?
            return c['data'] if c['data']['id'] == thing_id
          end
        end
      end
    end   
    nil
  rescue
    nil
  end



  def self.auth(username, password)
    response = HTTParty.post("#{RedditAPI.base_url}/api/login", body: {user: username, passwd: password})
    response.headers["set-cookie"].match(/reddit_session=[^\;]+/)[0]
  end

end