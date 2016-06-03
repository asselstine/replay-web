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
