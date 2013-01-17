require 'brigade/models'

# Add / remove the subreddits you want to crawl here

Subreddit.seed do |s| 
  s.id = 1
  s.name = "ShitRedditSays"
end

Subreddit.seed do |s| 
  s.id = 2
  s.name = "SRSSucks"
end

Subreddit.seed do |s|
  s.id = 3
  s.name = "SubredditDrama"
end

