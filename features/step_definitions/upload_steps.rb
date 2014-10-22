When(/^I attach a geoJSON file$/) do
  attach_file("geoJSON", File.join(File.dirname(__FILE__), '..', 'test_files/geojson.json'))
end

When(/^I click "(.*?)"$/) do |arg1|
  click_button(arg1)
end

When(/^I move the slider to (\d+)$/) do |arg1|
  sleep(3)
  page.execute_script("$('#slider').slider('option', 'programmatic', true)")
  page.execute_script("$('#slider').slider('value', #{arg1})")
  page.execute_script("$('#slider').slider('option', 'programmatic', false)")
  sleep(3)
end

When(/^I click on the event$/) do
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { marker.openPopup() });")
  sleep(3)
end


Then(/^the database size should be "(.*?)"$/) do |arg1|
  expect(Event.count).to eq arg1.to_i
end
