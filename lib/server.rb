require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'
require 'haml'


ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base

  get '/events' do
    content_type :json
    all_the_events = Event.all
    change_togfeatures_collection_json(all_the_events)
  end

  get '/upload' do
    @events = Event.all
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
    startdate = DateTime.iso8601(params["startdate"].to_s)
    enddate = params["enddate"] ? DateTime.iso8601(params["enddate"].to_s) : DateTime.iso8601(params["startdate"].to_s)
    tags = params["tags"].split(",").map do |tag|
      Tag.first_or_create(name: tag.strip)
    end
    linkedevents = []
    params["linkedevents"].each { |event_id|
      linkedevents << Event.get(event_id.to_i)
    } if params["linkedevents"]
    links = []
    links = [{ name: params["link-name"], url: params["link-url"] }] if params["link-name"] && params["link-url"]
    uploaded_event = {
      title: params["title"],
      short_description:params["short_description"],
      description:params["description"].gsub(/\n\n/, "\\n\\n"),
      geometry: geojson_geometry(params["longitude"], params["latitude"]),
      timescale: params["timescale"],
      startdate:startdate,
      enddate:enddate,
      tags:tags,
      events: linkedevents,
      links: links
    }
    new_event = Event.create(uploaded_event)
    new_event.reciprocate_event_links
    redirect to('/')
  end

  post '/upload' do
    Event.add_geojson_events(params[:geoJSON][:tempfile].read)
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