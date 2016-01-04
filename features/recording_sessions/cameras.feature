@javascript
Feature: Manage cameras for recording session

  Background:
    Given I'm logged in
    And I have an existing recording session

  Scenario: Create a new camera
    When I create a new camera for the recording session
    Then the camera should be listed in the recording session 

  Scenario: Start recording a video on a camera
    Given there is an existing camera for the session
    When I start recording a new video on the camera
    Then the camera should be shown as recording in the session
