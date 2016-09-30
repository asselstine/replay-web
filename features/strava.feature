Feature: Connect to Strava

  Background:
    Given I log in

  Scenario: Connect Strava Account
    When I go to settings
    And I connect to Strava
    Then my Strava account should be connected
    And it should synchronize my data
