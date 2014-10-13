env = ENV["RACK_ENV"] || "Development"
DataMapper.setup(:default, "postgres://localhost/MapToTheFuture-#{env}")

require './lib/model/event.rb'

DataMapper.finalize
DataMapper.auto_upgrade!
