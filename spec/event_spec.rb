require 'spec_helper'

describe Event do

  def create_event
      @event = Event.new( title: "Eiffel Tower",
        description: "Pioneer of aerodynamics Georges Eiffel created this tower for Universal Exhibition of 1889.",
        category: "Monument",
        date: DateTime.new(1889, 3,15),
        geometry: { type: "Point",
                    coordinates: [2.294694, 48.858093] })
  end

  it "should start with nothing" do
    expect(Event.count).to eq 0
  end

  context "Creating events" do

    it "should save an event in the database" do
      create_event
      @event.save
      expect(Event.count).to eq 1
      expect(Event.first(title: "Eiffel Tower").category).to eq "Monument"
    end

    it "must have an title, description, date and geometry" do
      bad_event1 = Event.new( title: "", description: "", category: "Bob" )
      expect(bad_event1.save).to be false
    end

  end

  context "Updating events" do
    it "should allow to update an event in the database" do
    create_event
    @event.save
    @event.update(title: "Construction of the Eiffel Tower")
    expect(@event.title).to eq "Construction of the Eiffel Tower"
    end
  end

  context "exporting geoJSON data" do
    it "should have a method to export as geoJSON data" do
      event = Event.new(title: "event", description: "event", date: DateTime.new(1900), geometry: { type: "Point", coordinates: [1.0, 1.0] })
      event.save
      expect(event.export_geojson).to eq('{"type":"Feature","properties":{"title":"event","description":"event","date":"1900-01-01T00:00:00+00:00"},"geometry":{"type":"Point","coordinates":[1.0,1.0]}}')
    end

    it "should have a method to export a geoJSON-Feature-ready hash object" do
      event = Event.new(title: "event", description: "event", date: DateTime.new(1900), geometry: { type: "Point", coordinates: [1.0, 1.0] })
      event.save
      expect(event.geojson_feature_hash).to eq({type: "Feature",properties:{title:"event",description:"event",date:DateTime.new(1900)},geometry:{type:"Point",coordinates:[1.0,1.0]}})
    end
  end

end
