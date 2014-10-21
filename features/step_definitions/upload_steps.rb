When(/^I attach a geoJSON file$/) do
  attach_file("geoJSON", File.join(File.dirname(__FILE__), '..', 'test_files/geojson.json'))
end

When(/^I click "(.*?)"$/) do |arg1|
  click_button(arg1)
end

Then(/^the database size should be "(.*?)"$/) do |arg1|
  expect(Event.count).to eq arg1.to_i
end
