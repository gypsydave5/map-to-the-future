require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'

ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base

  set :views, Proc.new { File.join(File.dirname(__FILE__), "../views") }

  get '/events' do
    all_the_events = Event.all
    features_collection_json(all_the_events)
  end

  get '/upload' do
    haml :upload
  end

  get '/' do
    erb :layout
  end

  run! if app_file == $0


end

def features_collection_json(array)
  feature_array = array.map {|feature_hash| feature_json(feature_hash)}
  {
    type: "FeatureCollection",
    features: feature_array
  }.to_json
end

def feature_json(hash)
      {
          type: "Feature",
        properties: {
            title: hash.title,
            description: hash.description,
            date: hash.date
          },
        geometry: hash.geometry
      }
end
