Feature: Connect to Strava

  Background:
    Given I'm logged in

  Scenario: Add Strava account
    When I go to settings
    And I connect to Strava
    Then my Strava account should be connected
