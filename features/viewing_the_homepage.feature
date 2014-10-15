Feature: Viewing the homepage
	As a history buff
	I should see the homepage with a map

  @javascript
	Scenario: Displaying the map
		Given I am a history buff
		When I go to the homepage
		Then I see a map