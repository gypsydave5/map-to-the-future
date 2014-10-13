require 'sinatra/base'
require 'data_mapper'
require 'datamapper_setup'

class MapToTheFuture < Sinatra::Base
  get '/' do
    'Hello MapToTheFuture!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
