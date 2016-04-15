Feature: Manage cameras for recording session

  Background:
    Given I'm logged in

  Scenario: Create a new camera
    When I create a new camera
    Then the camera should be listed

  @javascript
  Scenario: Update a camera location
    Given a camera exists
    When I update the camera location with my current location
    Then the camera location should be updated

  Scenario: Update a camera range
    Given a camera exists
    When I update the camera range to 20
    Then the camera range should be 20
