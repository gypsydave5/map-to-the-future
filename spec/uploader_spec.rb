require 'spec_helper'

describe 'uploader' do

def create_polar_bear_event
    fill_in "title", with: "Birth of a Polar Bear"
    fill_in "description", with: "A Mama Bear and a Papa Bear had a special hug. Months later, a polar cub was born. And his name was little Eric."
    fill_in "longitude", with: "-69.3322"
    fill_in "latitude", with: "77.4894"
    fill_in "timescale", with: "year"
    fill_in "startdate", with: "1968"
    fill_in "enddate", with: "1968"
    fill_in "tags", with: "Politics, Culture"
    fill_in "linkedevents", with: "Polar Bear Rises to fame"
end

def create_famous_polar_bear_event
    fill_in "title", with: "Polar Bear Rises to fame"
    fill_in "description", with: "Greedy Coca Cola officials think a cute polar bear will help them sell more cola. They choose Polar Bear as their mascot."
    fill_in "longitude", with: "74.0059"
    fill_in "latitude", with: "40.7127"
    fill_in "timescale", with: "year"
    fill_in "startdate", with: "1982"
    fill_in "enddate", with: "1982"
    fill_in "tags", with: "Culture"
    fill_in "linkedevents", with: "Birth of a Polar Bear"
end



	# it 'should allow to upload an event to the database' do
	# 	visit '/upload'
	# 	create_polar_bear_event
	# 	expect(Event).to receive(:fetch_relevant_events)
 #        page.execute_script('$("#slider").slider("value", 1968)')
 #    end

 #    it "should display the list of events on the page" do
 #        visit '/upload'
 #        create_polar_bear_event
 #        create_famous_polar_bear_event
 #        expect(page).to have_content("Birth of a Polar Bear")
 #        expect(page).to have_content("Polar Bear Rises to fame")
 #    end


end
