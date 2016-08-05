@javascript
Feature: Manage setups

  Background:
    Given I log in

  Scenario: Create a new setup
    When I create a new setup
    Then the setup should be listed

  Scenario: Create a static setup
    When I go to create a new setup
    And I enter the setup name
    And I select a static location and center it on my position
    And I create the new setup
    Then the setup should be a static location

  Scenario: Create a strava setup
    When I go to create a new setup
    And I enter the setup name
    And I select strava location
    And I create the new setup
    Then the setup should be for strava

  Scenario: Update a static setup
    Given a static setup exists
    When I go to edit the setup
    And I update the setup location with my current location
    And I update the setup range to 20
    And I save the existing setup
    Then the setup should be a static location
    And the setup range should be 20
