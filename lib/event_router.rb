require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'

ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base
  get '/events' do
    all_the_events = Event.all
    features_collection_json(all_the_events)
  end

  get '/upload' do
    haml :upload
  end

  post '/upload' do
    upload = JSON.parse(params[:geoJSON][:tempfile].read)
    upload["features"].each do |feature|
      Event.create({
        title: feature["properties"]["title"] || "",
        description: feature["properties"]["description"] || "",
        category: feature["properties"]["category"] || "",
        date: DateTime.new(feature["properties"]["date"].to_i) || DateTime.new,
        geometry: feature["geometry"] || ""
      })
    end
    "File uploaded!" + upload.to_s
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