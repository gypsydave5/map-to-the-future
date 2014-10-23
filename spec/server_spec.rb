require 'spec_helper'
require 'rack/test'
require 'helpers/event_spec_helpers'

describe 'router' do

  include Rack::Test::Methods
  include EventSpecHelpers

  def app
    MapToTheFuture
  end

  it 'should return an event' do
    event = point_event("Occurance", "description", "short_description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    events_array = [event]
    get '/events'
    expect(last_response.body).to eq features_response(events_array).to_json
  end

  it 'should return all the events in a FeatureCollection' do
    event = point_event("Occurance", "description", "short_description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    another_event = point_event("Marty", "McFly", "Michael J Fox", ["character"], 1985, 1985, "year", [1.0, 1.0])
    events_array = [event, another_event]
    response = features_response(events_array)
    response[:features][0][:properties][:id] = 7
    response[:features][1][:properties][:id] = 8
    get '/events'
    expect(last_response.body).to eq response.to_json
  end

  it 'should return events for a particular date from the database' do
    point_event("Occurance", "description", "short_description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    event_1985 = point_event("Marty", "McFly", "Michael J Fox", ["character"], 1985, 1985, "year", [1.0, 1.0])
    events_array = [event_1985]
    response = features_response(events_array)
    response[:features][0][:properties][:id] = 10
    get '/events/year/1985'
    expect(last_response.body).to eq response.to_json
  end
end
