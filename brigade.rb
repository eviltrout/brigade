#!/usr/bin/env ruby

require 'bundler'
Bundler.require(:default)

require 'brigade/brigade'


brigade = Brigade.new(YAML.load_file('config.yml'))
brigade.run
sleep

#Brigade.connect_db
#Brigade.crawl(2)