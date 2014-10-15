require 'spec_helper'

describe 'slider' do

 # include Rack::Test::Methods

  # def app
  #   MapToTheFuture
  # end



#  before(:each) do
# bigevent = Event.new(title: "DDay", description: "guys on a boat with guns land in France", start_date: "1944", end_date: "1944", time_scale: "year",  
# geometry: { type: "Point", coordinates: [-0.87108, 49.369681] })
# bigevent.save
 #  end


 #  it 'should receive the data relating to a certain date' do
 #    get '/events/1944'
 #    expect(page).to receive((title: "DDay", description: "guys on a boat with guns land in France", start_date: "1944", end_date: "1944", time_scale: "year").to_json)
# end

	it 'should display on the map the historical events from a certain date', :type => :feature, :js => true do
		visit '/'
	    page.execute_script('$("#slider").slider("value", 1944)')
	    expect(MapToTheFuture).to receive(:fetch_relevant_events)
	end


end
 #    post '/', {date:"1944"}.to_json, {}


 #    }
# expect().to receive(http://fdasfasd/1944)  

# it 'should display the events from the year selected by the slider'