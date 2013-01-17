require 'bundler'
Bundler.require(:default)

require 'active_record'

# Thanks: http://exposinggotchas.blogspot.ca/2011/02/activerecord-migrations-without-rails.html

MIGRATIONS_DIR = "db/migrate"
FIXTURE_PATHS = "db/fixtures"

namespace :db do

  task :configuration do
    @config = YAML.load_file('config.yml')['database']
  end

  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection(@config)
    ActiveRecord::Base.logger = Logger.new STDOUT if @config['logger']
  end

  desc 'Migrate the database (options: VERSION=x, VERBOSE=false).'
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback => :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end
 
  desc "Retrieves the current schema version number"
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end

  desc "Seed the database"
  task :seed => :configure_connection do
    SeedFu.seed(FIXTURE_PATHS)
  end

  desc "Reset the database"
  task :reset => :configure_connection do
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, 50
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, nil
    SeedFu.seed(FIXTURE_PATHS)
  end



end