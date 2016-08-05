Feature: Connect to Strava

  Background:
    Given I log in

  @queue
  Scenario: Add Strava account
    When I go to settings
    And I connect to Strava
    Then my Strava account should be connected
    And it should synchronize my data
