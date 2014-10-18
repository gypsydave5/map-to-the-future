Given(/^MapToTheFuture knows about the Boston Tea Party$/) do
  point_event("Boston Tea Party",
    "Boat unloads a lot of tea",
    ["Civil War"], 1773, 1773, "year", [-71.0597732, 42.3584308], "Declaration of Independance")
end

Given(/^MapToTheFuture knows about the Declaration of Independence$/) do

end

When(/^I click on the marker for "(.*?)"$/) do |arg1|

end



def point_event(name, description, tags, start_date, end_date, timescale, coords, events)
  Event.create({title: name,
                description: description,
                tags: tags.map{|tag| Tag.first_or_create(name: tag)},
                startdate: DateTime.new(start_date),
                enddate: DateTime.new(end_date),
                geometry: { type: "Point", coordinates: coords },
                events: linkedevents.map{|linkedevent| Event.first(title: linkedevents)}})
end