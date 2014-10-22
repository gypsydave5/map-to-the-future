Given(/^MapToTheFuture knows about the Boston Tea Party$/) do
  point_event("Boston Tea Party", "This is the short description",
    "Boat unloads a lot of tea",
    ["Civil War"], 1773, 1773, "year", [-71.0597732, 42.3584308], ["Declaration of Independence"])
end

Given(/^MapToTheFuture knows about the Declaration of Independence$/) do
  point_event("Declaration of Independence", "This is the short description",
    "American colonies declare independence from Great Britain",
    ["Civil War"], 1776, 1776, "year", [-75.15, 39.948889], [])
end

When(/^I click on the marker for "(.*?)"$/) do |marker_title|
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { if (marker.feature.properties.title === '#{marker_title}') { marker.fire('click') } });")
end

When(/^I click on the "(.*?)" tab$/) do |arg1|
  sleep(3)
  page.execute_script("$('input##{arg1}').click()")
  sleep(3)
end

When(/^I click on the event link "(.*?)"$/) do |arg1|
  page.execute_script("$('.linked-event').click()")
end

Then(/^the slider should be on "(.*?)"$/) do |arg1|
  expect(page).to have_content("1776")
end

Then(/^the "(.*?)" popup should be open$/) do |event_name|
  expect(page.evaluate_script("$('div.content h1').text()")).to eql event_name
end

Given(/^I am looking at North America$/) do
  page.execute_script("map.panTo([39.948889,-75.15])")
end

def point_event(name, short_description, description, tags, start_date, end_date, timescale, coords, events)
  Event.new({title: name,
                short_description: short_description,
                description: description,
                tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                startdate: DateTime.new(start_date),
                enddate: DateTime.new(end_date),
                geometry: { type: "Point", coordinates: coords },
                events: events.map{|linked_event|
                  Event.first(title: linked_event)}}).save
end