Feature: Manage cameras for recording session

  Background:
    Given I'm logged in
    And I have an existing recording session

  Scenario: Create a new camera
    When I create a new camera for the recording session
    Then the camera should be listed in the recording session 
