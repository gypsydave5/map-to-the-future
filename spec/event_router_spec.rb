require 'spec_helper'
require 'rack/test'

describe 'router' do

  include Rack::Test::Methods

  def app
    MapToTheFuture
  end

  it 'should return all the events' do
    event = {title: "event", description: "event", date: DateTime.new(1900).new_offset(1.0/24), geometry: { type: "Point", coordinates: [1.0, 1.0] }}
    Event.create(event)
    get '/events'
    expect(last_response.body).to eq features_response_json(event)
  end

def features_response_json(hash)
  {
    type: "FeatureCollection",
    features: [
      type: "Feature",
      properties: {title: hash[:title], description: hash[:description], date: hash[:date]},
      geometry: hash[:geometry]
    ]
  }.to_json
end

end
