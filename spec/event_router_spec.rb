require 'spec_helper'
require 'rack/test'

describe 'router' do

  include Rack::Test::Methods

  def app
    MapToTheFuture
  end

  it 'should return an event' do
    event = {title: "event", description: "event", date: DateTime.new(1900), geometry: { type: "Point", coordinates: [1.0, 1.0] }}
    Event.create(event)
    get '/events'
    events_array = [event]
    expect(last_response.body).to eq features_response_json(events_array)
  end

  it 'should return all the events in a FeatureCollection' do
    event = {title: "event", description: "event", date: DateTime.new(1900), geometry: { type: "Point", coordinates: [1.0, 1.0] }}
    another_event  = {title: "more", description: "more", date: DateTime.new(1901), geometry: { type: "Point", coordinates: [2.0, 2.0] }}
    events_array = [event, another_event]
    Event.create(event)
    Event.create(another_event)
    get '/events'
    expect(last_response.body).to eq features_response_json(events_array)
  end

  def features_response_json(array)
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
              title: hash[:title],
              description: hash[:description],
              date: hash[:date]
            },
          geometry: hash[:geometry]
        }
  end

end
