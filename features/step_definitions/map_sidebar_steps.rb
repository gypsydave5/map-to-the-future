Given(/^I have opened the popup for "(.*?)"$/) do |event|
  sleep(3)
  page.execute_script("eventLayer.eachLayer(function(marker) { { marker.fire('click') } });")
end

When(/^I click the 'read more' link$/) do
  page.execute_script("$('.sidebar-caller').click()")
end
