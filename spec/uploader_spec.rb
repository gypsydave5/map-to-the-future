require 'spec_helper'

describe 'uploader' do

  def create_polar_bear_event
    fill_in "title", with: "Birth of a Polar Bear"
    fill_in "short_description", with: "A bear called Eric"
    fill_in "description", with: "A Mama Bear and a Papa Bear had a special hug. Months later, a polar cub was born. And his name was little Eric."
    fill_in "longitude", with: "-69.3322"
    fill_in "latitude", with: "77.4894"
    fill_in "timescale", with: "year"
    fill_in "startdate", with: "1968"
    fill_in "enddate", with: "1968"
    fill_in "tags", with: "Politics, Culture"
    click_button "Publish"
  end

  def create_famous_polar_bear_event
    fill_in "title", with: "Polar Bear Rises to fame"
    fill_in "short_description", with: "Eric gets involved with Coca-Cola"
    fill_in "description", with: "Greedy Coca Cola officials think a cute polar bear will help them sell more cola. They choose Polar Bear as their mascot."
    fill_in "longitude", with: "74.0059"
    fill_in "latitude", with: "40.7127"
    fill_in "timescale", with: "year"
    fill_in "startdate", with: "1982"
    fill_in "enddate", with: "1982"
    fill_in "tags", with: "Culture"
    select "Birth of a Polar Bear", from: "linkedevents[]"
    click_button "Publish"
  end

  it 'should allow to upload an event to the database' do
    visit '/upload'
    create_polar_bear_event
    expect(Event.all.size).to eql 1
  end

  it 'should link events together' do
    visit '/upload'
    create_polar_bear_event
    visit '/upload'
    create_famous_polar_bear_event
    expect(Event.first(title: "Polar Bear Rises to fame").events.first.title).to eql "Birth of a Polar Bear"
  end

  it 'should link events both ways' do
    visit '/upload'
    create_polar_bear_event
    visit '/upload'
    create_famous_polar_bear_event
    expect(Event.first(title: "Birth of a Polar Bear").events.first.title).to eql "Polar Bear Rises to fame"
  end

end
