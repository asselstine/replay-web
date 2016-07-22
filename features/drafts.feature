@javascript
Feature: Drafts

  Background:
    Given I'm logged in
    And I have an activity

  Scenario: Browse video drafts
    Given I have a video draft
    When I browse drafts
    Then my video draft is listed
    When I click on the video draft
    Then I should be able to play the video draft

  Scenario: Video update triggers segment effort video
    Given I have a segment effort
    And there is a video upload
    And the video upload is updated with the effort timestamp
    When I browse drafts
    Then I can see the segment effort video

#  Scenario: Segment effort update triggers segment effort video
