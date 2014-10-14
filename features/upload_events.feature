Feature: Uploading data
    As the developer of MapToTheFuture
    I want to be abe to upload geoJSON data to my database

    Scenario: Visiting the upload route
        Given I am on the upload page
        Then I should see "GeoJSON file: "
        And I should see "Submit"
