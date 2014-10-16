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
    title = params["title"]
    description = params["description"]
    longitude = params["longitude"]
    latitude = params["latitude"]
    timescale = params["timescale"]
    startdate = params["startdate"] 
    enddate = params["enddate"]
    tags = params["tags"].split(",").map do |tag|
      Tag.first_or_create(text: tag)
    end
    linkedevents = params["linkedevents"].split(",").map do |linkedevent|
      Event.first(title: "#{linkedevent}") 
    end
    geometry = geojson_look_alike(longitude, latitude)

    Event.create(title:title, description:description, geometry: geometry, timescale:timescale,startdate:startdate,enddate:enddate,tags:tags, linkedevent:linkedevent)
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

def geojson_look_alike(long, lat)
    geojson_hash = {
      geometry: '{
              "type": "Point",
              "coordinates": [#{long}, #{lat}]
      }'
    }
    return geojson_hash
end