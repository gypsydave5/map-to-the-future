require 'sinatra/base'
require 'data_mapper'
require './lib/datamapper_setup'

class MapToTheFuture < Sinatra::Base
  get '/events' do
    all_the_events = Event.all
    features_response_json(all_the_events[0])
  end

  # start the server if ruby file executed directly
  run! if app_file == $0


def features_response_json(event)
  {
    type: "FeatureCollection",
    features: [
      type: "Feature",
      properties: {title: event.title, description: event.description, date: event.date},
      geometry: event.geometry
    ]
  }.to_json
end



end
