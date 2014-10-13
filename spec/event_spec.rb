require 'spec_helper'

describe Event do

  it "should start with nothing" do
    expect(Event.count).to eq 0
  end

  #it "should save an event in the database" do

    #event = Event.new
    #( title: "Eiffel Tower",
                      #description: "Pioneer of aerodynamics Georges Eiffel created this tower for Universal Exhibition of 1889.",
                      #category: "Monument",
                      #date: DateTime.new(1889, 3,15),
                      #geometry: { type: "Point",
                                  #coordinates: [2.294694, 48.858093] })
    #event.save
    #expect(Event.get(title: "Eiffel Tower").category).to eq "Monument"
  #end

end
