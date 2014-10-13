require 'spec_helper'

describe Event do

  it "should start with nothing" do
    expect(Event.count).to eq 0
  end

  context "Creating events" do

    it "should save an event in the database" do

      event = Event.new( title: "Eiffel Tower",
        description: "Pioneer of aerodynamics Georges Eiffel created this tower for Universal Exhibition of 1889.",
        category: "Monument",
        date: DateTime.new(1889, 3,15),
        geometry: { type: "Point",
                    coordinates: [2.294694, 48.858093] })
      event.save
      expect(Event.count).to eq 1
      expect(Event.first(title: "Eiffel Tower").category).to eq "Monument"
    end

    it "must have an title, description, date and geometry" do
      bad_event1 = Event.new( title: "", description: "", category: "Bob" )
      expect{bad_event1.save}.to raise_error
    end

  end

end
