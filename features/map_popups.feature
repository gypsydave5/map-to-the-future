Feature: Interacting with map pop ups
  As a history buff
  When I click on markers in MapToTheFuture
  I want to interact with the informative pop ups

  @javascript @selenium
  Scenario: Opening a pop up
    Given I am on the homepage
    And the Timeline app knows The Battle of Dresden Anniversary
    And I move the slider to "1913"
    When I click on the marker for "The Battle of Dresden Anniversary"
    Then I should see "Dresden"

  @javascript @selenium
  Scenario: Displays links between events
    Given I am on the homepage
    And MapToTheFuture knows about the Declaration of Independence
    And MapToTheFuture knows about the Boston Tea Party
    And I move the slider to "1773"
    When I click on the marker for "Boston Tea Party"
    And I click on the "linked-events" tab
    Then I should see "Declaration of Independence"

  @javascript @selenium
  Scenario: Links between events take you to to the linked event
    Given I am on the homepage
    And MapToTheFuture knows about the Declaration of Independence
    And MapToTheFuture knows about the Boston Tea Party
    And I move the slider to "1773"
    When I click on the marker for "Boston Tea Party"
    And I click on the "linked-events" tab
    And I click on the event link "Declaration of Independence"
    Then the slider should be on "1776"
    And the "Declaration of Independence" popup should be open
