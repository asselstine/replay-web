@javascript
Feature: Upload videos

  Background:
    Given I'm logged in

  Scenario: Upload a video
    Given there is a setup
    When I go to upload a video
    And I add a video
    And I select a setup
    And I upload the video
    Then the video upload should be listed
    And the video upload should include the setup

  Scenario: Set the timestamps for a video
    Given there is a video upload
    When I scrub to the slate and set the timestamp
    Then I should see the adjusted start and end times
    When I update the video
    Then the video should have correct start and end times
    And the video should have the correct duration
