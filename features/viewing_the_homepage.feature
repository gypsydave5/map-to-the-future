Feature: Viewing the homepage
  As a history buff
  I should see the homepage with a map

  @javascript
  Scenario: Displaying the map
    When I go to the homepage
    Then I see a map

  @javascript
  Scenario: Moving the slider to an event
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    When I move the slider to "1913"
    Then I should see a marker

  @javascript
  Scenario: Moving the slider to a lack of events
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    When I move the slider to "1914"
    Then I should not see a marker

  @javascript @selenium
  Scenario: Moving the slider removes events
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    And I move the slider to "1913"
    When I move the slider to "1914"
    Then I should not see a marker

  @javascript @selenium
  Scenario: Opening a pop up
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    And I move the slider to "1913"
    When I click on the marker
    Then I should see "Dresden"