@javascript
Feature: Drafts

  Background:
    Given I'm logged in

  Scenario: Browse video drafts
    Given I have a video draft
    When I browse drafts
    Then my video draft is listed
    When I click on the video draft
    Then I should be able to play the video draft

  Scenario: Video upload triggers video drafting
    Given I have a segment effort
    And I have a video upload
    And there is a setup
    And the video upload belongs to the setup
    And the video upload is updated with the effort timestamp
    And I browse drafts
    Then I can see a video draft
    And I can see the segment effort

  Scenario: New segment effort triggers video drafting
    Given I have a video upload
    And there is a setup
    And the video upload belongs to the setup
    And the video upload has timestamps
    When I have a new activity during the video upload near the setup
    And I browse drafts
    Then I can see a video draft
