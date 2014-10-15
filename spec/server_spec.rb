require 'spec_helper'
require 'rack/test'

describe 'router' do

  include Rack::Test::Methods

  def app
    MapToTheFuture
  end

  it 'should return an event' do
    event = point_event("Occurance", "description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    get '/events'
    events_array = [event]
    expect(last_response.body).to eq features_response_json(events_array)
  end

  it 'should return all the events in a FeatureCollection' do
    event = point_event("Occurance", "description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    another_event = point_event("Marty", "McFly", ["character"], 1985, 1985, "year", [1.0, 1.0])
    events_array = [event, another_event]
    get '/events'
    expect(last_response.body).to eq features_response_json(events_array)
  end

  it 'should reuturn events for a particular date from the database' do
    event_1900 = point_event("Occurance", "description", ["event"], 1900, 1900, "year", [1.0, 1.0])
    event_1985 = point_event("Marty", "McFly", ["character"], 1985, 1985, "year", [1.0, 1.0])
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

  def feature_json(event)
        {
            type: "Feature",
          properties: {
              id: 4,
              title: event[:title],
              description: event[:description],
              startdate: event[:startdate],
              enddate: event[:enddate],
              timescale: event[:timescale],
              events: [],
              tags: event.tags.map(&:name)
            },
          geometry: event[:geometry]
        }
  end

  def point_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name,
                  description: description,
                  tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                  startdate: DateTime.new(start_date),
                  enddate: DateTime.new(end_date),
                  geometry: { type: "Point", coordinates: coords }})
  end

  def line_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name, description: description, tags: tags, startdate: DateTime.new(start_date), enddate: DateTime.new(end_date), geometry: { type: "LineString", coordinates: coords }})
  end

  def polygon_event(name, description, tags, start_date, end_date, timescale, coords)
    Event.create({title: name, description: description, tags: tags, date: DateTime.new(start_date), enddate: DateTime.new(end_date), geometry: { type: "Polygon", coordinates: coords }})
  end

end
