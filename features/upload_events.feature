Feature: Uploading data
    As the developer of MapToTheFuture
    I want to be abe to upload geoJSON data to my database

    Scenario: Visiting the upload route
        Given I am on the upload page
        Then I should see "GeoJSON file: "

    Scenario: Uplading a file
        Given I am on the upload page
        When I attach a geoJSON file
        And I click "Submit"
        Then I should be on the homepage
        And the database size should be "1"
