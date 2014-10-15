require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'

ENV['TZ'] = 'utc'

class MapToTheFuture < Sinatra::Base

  #set :views, Proc.new { File.join(File.dirname(__FILE__), "/views") }

  get '/events' do
    p Event.all
    all_the_events = Event.all
    change_to_features_collection_json(all_the_events)
  end

  get '/upload' do
    haml :upload
  end

  get '/events/year/:year' do
    event = Event.fetch_relevant_events(params[:year])
    change_to_features_collection_json(events)
  end

  post '/upload' do
    upload = JSON.parse(params[:geoJSON][:tempfile].read)
    upload["features"].each do |feature|
      event = { geometry: feature["geometry"] }
      feature["properties"].keys.each do |key|
        if key =~ /date/
          event[key.to_sym] = DateTime.new(feature["properties"][key].to_i)
        elsif key == "tags"
          event[key.to_sym] = feature["properties"][key].map{|tag| Tag.first_or_create(name: tag)}
        elsif key == "events"
          event[key.to_sym] = feature["properties"][key].map do |linked_event|
            Event.get(linked_event["id"].to_i)
          end
        else
          event[key.to_sym] = feature["properties"][key]
        end
      end
      Event.create(event)
    end
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
