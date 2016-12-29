@javascript
Feature: Upload videos

  Background:
    Given I log in

  @perform_jobs @stub_et_success
  Scenario: Upload a video
    Given there is a setup
    When I go to upload
    And I add a video
    And I select a setup
    And I finish the video upload
    And the video upload job completes
    Then the video upload should be listed
    And the upload should include the setup

  Scenario: Set the timestamps for a video
    Given I have a video upload
    When I update the video upload timestamp
    Then the video should have correct start and end times
    And the video should have the correct duration
