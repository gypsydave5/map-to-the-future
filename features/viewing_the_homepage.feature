Feature: Viewing the homepage
    As a history buff
    I should see the homepage with a map

    @javascript
    Scenario: Displaying the map
        When I go to the homepage
        Then I see a map

    @javascript
    Scenario: Moving the slider
        Given I am on the homepage
        And that the Timeline app knows The Battle of Dresden
        When I move the slider to "1813"
        And I click on the marker
        Then I should see "Dresden"