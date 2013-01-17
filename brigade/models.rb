class Subreddit < ActiveRecord::Base
  has_many :submissions

  validates_presence_of :name
  validates_uniqueness_of :name
end

class Submission < ActiveRecord::Base
  belongs_to :subreddit  
  has_many :links

  validates_presence_of :reddit_id
  validates_uniqueness_of :reddit_id
  validates_presence_of :subreddit_id
  validates_presence_of :title
  validates_presence_of :permalink
  validates_presence_of :submission_date
end

class Link < ActiveRecord::Base
  belongs_to :submission  
  validates_presence_of :url
end

class LinkScore < ActiveRecord::Base
  belongs_to :link
  validates_presence_of :ups, :downs, :score
end