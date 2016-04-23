Feature: Upload videos

  Background:
    Given I'm logged in

  Scenario: Upload a video
    When I upload a video
    And I create the video
    Then there should be a new video

  @javascript
  Scenario: Set the timestamps for a video
    Given there is a video
    When I scrub to the slate and set the timestamp
    Then I should see the adjusted start and end times
    When I update the video
    Then the video should have correct start and end times
    And the video should have the correct duration
