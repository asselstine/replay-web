@javascript
Feature: Upload videos

  Background:
    Given I log in

  Scenario: Upload a video
    Given there is a setup
    When I go to upload
    And I add a video
    And I select a setup
    And I finish the video upload
    Then the video upload should be listed
    And the upload should include the setup

  Scenario: Set the timestamps for a video
    Given I have a video upload
    When I update the video upload timestamp
    Then the video should have correct start and end times
    And the video should have the correct duration

  Scenario: Upload a photo
    Given there is a setup
    When I go to upload
    And I add a photo
    And I select a setup
    And I finish the photo upload
    Then the photo upload should be listed
    And the upload should include the setup

  Scenario: View a photo
    Given there is a photo upload
    When I view the upload
    Then I should see the photo
