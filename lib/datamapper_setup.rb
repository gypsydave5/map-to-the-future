env = ENV["RACK_ENV"] || "Development"
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/MapToTheFuture-#{env}")

require './lib/model/event.rb'
require './lib/model/tag.rb'

DataMapper.finalize
DataMapper.auto_upgrade!
