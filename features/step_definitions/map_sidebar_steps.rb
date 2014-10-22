Given(/^I have opened the popup for "(.*?)"$/) do |event|
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { { marker.fire('click') } });")
end

When(/^I click the 'read more' link$/) do
  sleep(2)
  page.execute_script("$('.sidebar-caller').click()")
  sleep(2)
end

Then(/^I should not see the sidebar$/) do
  sleep(5)
  expect(page).not_to have_css('#sidebar')
  sleep(5)
end
