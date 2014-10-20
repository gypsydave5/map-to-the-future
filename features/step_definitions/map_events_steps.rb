Then(/^I see a map$/) do
  expect(page).to have_css('div.leaflet-container')
end

Given(/^the Timeline app knows The Battle of Dresden Anniversary$/) do
  point_event("The Battle of Dresden Anniversary",
    "Marshall Saint-Cyr defends Dresden from the Allied assault, and is relieved by Napoleon and the dashing Marshall Murat, who inflict a heavy defeat on the Austrians but fail to pursue due to Napoleon's ill-health",
    ["Battle"], 1913, 1913, "year", [13.733333, 51.033333], [])

end

When(/^I move the slider to "(.*?)"$/) do |year|
  page.execute_script("$('#slider').slider('value', #{year})")
end

When(/^I click on the marker$/) do
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { marker.openPopup() });")
end

Then(/^I should see a marker$/) do
  expect(page).to have_css('img.leaflet-marker-icon')
end

Then(/^I should not see a marker$/) do
  sleep(3)
  expect(page.evaluate_script("Object.keys(eventLayer._layers).length")).to eq(0)
end

Then(/^the map zooms in to Dresden$/) do
  sleep(3)
  expect(map).to receive(:panTo)
end


def point_event(name, description, tags, start_date, end_date, timescale, coords, events)
  Event.create({title: name,
                description: description,
                tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                startdate: DateTime.new(start_date),
                enddate: DateTime.new(end_date),
                geometry: { type: "Point", coordinates: coords },
                events: linkedevents
                })
end
