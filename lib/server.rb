require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'
require 'haml'


ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base

  get '/events' do
    content_type :json
    all_the_events = Event.all
    change_to_features_collection_json(all_the_events)
  end

  get '/upload' do
    haml :upload
  end

  get '/test_layout' do
    erb :test_layout
  end

  get '/events/year/:year' do
    searched_events = Event.fetch_relevant_events(params[:year])
    searched_events ||= []
    change_to_features_collection_json(searched_events)
  end

  post "/upload/formpost" do
    startdate = DateTime.new(params["startdate"].to_i)
    enddate = params["enddate"] ? DateTime.new(params["enddate"].to_i) : DateTime.new(params["startdate"].to_i)
    tags = params["tags"].split(",").map do |tag|
      Tag.first_or_create(name: tag.strip)
    end
    linkedevents = []
    params["linkedevents"].split(",").each do |linkedevent|
       linkedevents << Event.first(title: linkedevent.strip) if Event.first(title: linkedevent.strip)
    end
    uploaded_event = {
      title: params["title"],
      description:params["description"],
      geometry: geojson_geometry(params["longitude"], params["latitude"]),
      timescale: params["timescale"],
      startdate:startdate,
      enddate:enddate,
      tags:tags,
      events: linkedevents
    }
    Event.create(uploaded_event)
    "Event uploaded!"
    redirect to('/')
  end

  post '/upload' do
    upload = Event.add_geojson_events(params[:geoJSON][:tempfile].read)
    "File uploaded!" + upload.to_s
    redirect to('/')
  end

  get '/' do
    erb :map_page
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

def geojson_geometry(long, lat)
    {
              type: "Point",
              coordinates: [long, lat]
      }
end