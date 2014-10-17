Then(/^I see a map$/) do
  expect(page).to have_css('div.leaflet-container')
end

Given(/^that the Timeline app knows The Battle of Dresden anniversary$/) do
  point_event("The Battle of Dresden Anniversary",
    "Marshall Saint-Cyr defends Dresden from the Allied assault, and is relieved by Napoleon and the dashing Marshall Murat, who inflict a heavy defeat on the Austrians but fail to pursue due to Napoleon's ill-health",
    ["Battle"], 1913, 1913, "year", [13.733333, 51.033333])
end

When(/^I move the slider to "(.*?)"$/) do |year|
  page.execute_script("$('#slider').slider('value', #{year})")
end

When(/^I click on the marker$/) do
  page.execute_script("map.fireEvent('click', {latlng: L.latLng(51.033333, 13.733333)});")
end

Then(/^I should see a marker$/) do
  expect(page).to have_css('.leaflet-marker-icon')
  
end

Then(/^I should not see a marker$/) do
  expect(page).not_to have_css('.leaflet-marker-icon')
end

When(/^I wait for all Ajax requests to complete$/) do
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end



def point_event(name, description, tags, start_date, end_date, timescale, coords)
  Event.create({title: name,
                description: description,
                tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                startdate: DateTime.new(start_date),
                enddate: DateTime.new(end_date),
                geometry: { type: "Point", coordinates: coords }})
end
