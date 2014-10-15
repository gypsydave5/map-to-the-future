require 'spec_helper'
require 'rack/test'

describe 'router' do

  include Rack::Test::Methods

  def app
    MapToTheFuture
  end

  it 'should return an event' do
    event = point_event("event", "description", "event", 1900, [1.0, 1.0])
    get '/events'
    events_array = [event]
    expect(last_response.body).to eq features_response_json(events_array)
  end

  it 'should return all the events in a FeatureCollection' do
    event = point_event("event", "description", "event", 1900, [1.0, 1.0])
    another_event = point_event("Marty", "McFly", "Character", 1985, [1.0, 1.0])
    events_array = [event, another_event]
    get '/events'
    expect(last_response.body).to eq features_response_json(events_array)
  end

  it 'should reuturn events for a particular date from the database' do
    event_1900 = point_event("event", "description", "event", 1900, [1.0, 1.0])
    event_1985 = point_event("Marty", "McFly", "Character", 1985, [1.0, 1.0])
    events_array = [event_1985]
    get '/events/year/1985'
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

  def point_event(name, description, category, year, coords)
    Event.create({title: name, description: description, category: category, date: DateTime.new(year), geometry: { type: "Point", coordinates: coords }})
  end

  def linestring_event(name, description, category, year, coords)
    Event.create({title: name, description: description, category: category, date: DateTime.new(year), geometry: { type: "LineString", coordinates: coords }})
  end

  def polygon_event(name, description, category, year, coords)
    Event.create({title: name, description: description, category: category, date: DateTime.new(year), geometry: { type: "Polygon", coordinates: coords }})
  end

end
