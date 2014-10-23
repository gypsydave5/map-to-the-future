Feature: Interacting with the events
  As a history buff
  When I use MapToTheFuture
  I should be able to interact with events on the map

  @javascript
  Scenario: The map has no zoom buttons
    Given I am on the homepage
    Then I should see no zoom buttons

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


