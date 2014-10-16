require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'
require 'haml'

ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base

  get '/events' do
    all_the_events = Event.all
    change_to_features_collection_json(all_the_events)
  end

  get '/upload' do
    haml :upload
  end

  get '/events/year/:year' do
    events = Event.fetch_relevant_events(params[:year])
    events ||= []
    change_to_features_collection_json(events)
  end

  post '/upload' do
    upload = Event.add_geojson_events(params[:geoJSON][:tempfile].read)
    "File uploaded!" + upload.to_s
  end

  get '/' do
    erb :layout
  end

  run! if app_file == $0

end

def change_to_features_collection_json(array)
  feature_array = array.map {|event| event.to_geojson_feature}
  {
    type: "FeatureCollection",
    features: feature_array
  }.to_json
end
