Feature: Manage cameras for recording session

  Background:
    Given I'm logged in
    And I have an existing recording session

  Scenario: Create a new camera
    When I create a new camera for the recording session
    Then the camera should be listed in the recording session 

  @javascript
  Scenario: Update a camera location
    Given there is an existing camera for the session 
    When I update the camera location with my current location
    Then the camera location should be updated

  Scenario: Update a camera range
    Given there is an existing camera for the session
    When I update the camera range to 20
    Then the camera range should be 20
