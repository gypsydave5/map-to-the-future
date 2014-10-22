Feature: Interacting with map pop ups
  As a history buff
  When I look at events in MapToTheFuture
  I want to get more information in a side bar

  @javascript @selenium
  Scenario: Opening the sidebar
    Given I am on the homepage
    And MapToTheFuture knows about the Declaration of Independence
    And I am looking at North America
    And I move the slider to "1776"
    And I have opened the popup for "the Declaration of Independence"
    When I click on the "title" tab
    And I click the 'read more' link
    Then I should see "The Declaration of Independence is the usual name of a statement adopted by the Continental Congress"
