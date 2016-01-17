Feature: Upload videos to a camera in a recording session

  Background:
    Given I'm logged in 
    And I have an existing recording session
    And there is an existing camera for the session

  Scenario: Upload a video to a camera
    When I upload a video to the camera
    And I create the video
    Then there should be a new video for the camera
