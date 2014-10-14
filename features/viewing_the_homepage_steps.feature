Feature: Viewing the homepage
	As a history buff
	I should see the homepage with a map

	Scenario: Displaying the map
		Given I am on the homepage
		When I look at the page
		Then I see a map