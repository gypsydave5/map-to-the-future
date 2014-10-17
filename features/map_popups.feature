Feature: Interacting with map pop ups
  As a history buff
  When I click on markers in MapToTheFuture
  I want to interact with the informative pop ups

  @javascript @selenium
  Scenario: Opening a pop up
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    And I move the slider to "1913"
    When I click on the marker
    Then I should see "Dresden"

  Scenario: Links between events
    Given I am on the homepage
    And MapToTheFuture knows about the Boston Tea Party
    And MapToTheFuture knows about the Declaration of Independence
    And I move the slider to "1773"
    When I click on the marker for "Boston Tea Party"
    Then I should see "Declaration of Independence"
