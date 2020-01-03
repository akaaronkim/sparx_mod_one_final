require "bundler/setup"
Bundler.require
require "sinatra/activerecord"
require "ostruct"
require "date"
require_all 'app/models'
require "json"
require "pry"
require "rest-client"
require "optparse"
require "http"
require "rainbow"


ENV["SINATRA_ENV"] ||= 'development'
ActiveRecord::Base.establish_connection(ENV["SINATRA_ENV"].to_sym)
#rake tasks are going to fail if below line is active
#when rake drop or migrate comment out line
ActiveRecord::Base.logger.level = 1 

