require 'spec_helper'

describe 'slider' do

  it 'should display on the map the historical events from a certain date', :type => :feature, :js => true do
    expect(Event).to receive(:fetch_relevant_events)
    visit '/'
    page.execute_script('$("#slider").slider("value", 1944)')
  end

end