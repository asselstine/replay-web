@javascript
Feature: Manage setups

  Background:
    Given I'm logged in

  Scenario: Create a new setup
    When I create a new setup
    Then the setup should be listed

  Scenario: Update a setup
    Given a setup exists
    When I go to edit the setup
    And I update the setup location with my current location
    And I update the setup range to 20
    And I save the existing setup
    Then the setup location should be updated
    And the setup range should be 20
