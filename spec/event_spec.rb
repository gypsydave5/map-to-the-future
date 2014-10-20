require 'spec_helper'

describe Event do

  def create_event
      @event = Event.new( title: "Eiffel Tower",
        description: "Pioneer of aerodynamics Georges Eiffel created this tower for Universal Exhibition of 1889.",
        tags: [Tag.first_or_create(name: "Monument")],
        startdate: DateTime.new(1889, 3,15),
        enddate: DateTime.new(1889, 3,15),
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
      expect(Event.first(title: "Eiffel Tower").tags.first.name).to eq "Monument"
    end

    it "must have an title, description, date and geometry" do
      bad_event1 = Event.new( title: "", description: "", tags: [Tag.first_or_create( name: "Bob" )] )
      expect(bad_event1.save).to be false
    end
  end

  context "connecting events" do
    it "can connect events together" do
      create_event
      @event.save
      Event.create(title: "Alex Eiffel",
                  description: "Pioneer of aerodynamics",
                  tags:[],
                  startdate: DateTime.new(1889, 3,15),
                  enddate: DateTime.new(1889, 3,15),
                  geometry: { type: "Point",
                    coordinates: [2.29, 48.85] },
                  events: [Event.first(title: "Eiffel Tower")]
                  )
      expect(Event.first(title: "Alex Eiffel").events.first.title ).to eql "Eiffel Tower"
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
    it "should have a method to export a geoJSON-Feature-ready hash object" do
      event = Event.new(title: "event", description: "event", startdate: DateTime.new(1900), enddate: DateTime.new(1900), geometry: { type: "Point", coordinates: [1.0, 1.0] })
      event.save
      expect(event.to_geojson_feature).to eq({type: "Feature",properties:{id: 5, title:"event",description:"event", startdate:DateTime.new(1900), enddate:DateTime.new(1900), timescale: nil, tags: [], events: []},geometry:{type:"Point",coordinates:[1.0,1.0]}})
    end
  end

end
