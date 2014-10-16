require 'spec_helper'
require 'helpers/event_spec_helpers'

describe 'slider' do

  include EventSpecHelpers

  it 'should display on the map the historical events from a certain date', :type => :feature, :js => true do
    visit '/'
    point_event("Birth of a Polar Bear", "Mr. Bear was born as a result of a special bear hug.", ["politics"], 1974, 1974, "year", [-0.871084, 49.369681])
    expect(Event).to receive(:fetch_relevant_events)
    page.execute_script('$("#slider").slider("value", 1944)')
	end

 #  it 'Creates a marker on the map with the event id as its id', :type => :feature, :js => true do
 #    visit '/'
 #    point_event("Birth of a Polar Bear", "Mr. Bear was born as a result of a special bear hug.", ["politics"], 1974, 1974, "year", [-0.871084, 49.369681])
 #    expect(Event).to receive(:fetch_relevant_events)
 #    page.execute_script('$("#slider").slider("value", 1944)')
	# end

end
