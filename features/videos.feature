Feature: Upload videos to a camera in a recording session

  Background:
    Given I'm logged in
    And there is a camera

  Scenario: Upload a video to a camera
    When I upload a video to the camera
    And I create the video
    Then there should be a new video for the camera

  @javascript
  Scenario: Set the timestamps for a video
    Given there is a video
    When I scrub to the slate and set the timestamp
    Then I should see the adjusted start and end times
    When I update the video
    Then the video should have correct start and end times
    And the video should have the correct duration
