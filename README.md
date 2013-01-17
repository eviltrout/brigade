## Analyze voting patterns of various reddit voting brigades.

### About

This was written for [a blog post I wrote](http://eviltrout.com/2013/01/16/crawling-the-downvote-brigades-of-reddit.html). There are probably bugs, use at your own risk.

It was my first project in JRuby + Celluloid. It ran quite well for many days. Celluloid is awesome sauce!


### To setup:

1. edit `config/database.yml` and point it at a new database
2. `rake db:migrate`
3. Review the list of subreddits we'll crawl in `db/fixtures/subreddits.rb`
4. `rake db:seed`


