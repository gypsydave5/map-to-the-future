Feature: Uploading data
    As the developer of MapToTheFuture
    I want to be abe to upload geoJSON data to my database

    Scenario: Visiting the upload route
        Given I am on the upload page
        Then I should see "GeoJSON file: "

    Scenario: Uploading a file
        Given I am on the upload page
        When I attach a geoJSON file
        And I click "Submit"
        Then I should be on the homepage
        And the database size should be "2"

    @javascript
    Scenario: Uploading a file with linked events
        Given I am on the upload page
        And I attach a geoJSON file
        And I click "Submit"
        And I am on the homepage
        When I move the slider to 1903
        And I click on the event
        And I click on the "Linked Event" tab
        Then I should see "Somewhere in Greenland"
