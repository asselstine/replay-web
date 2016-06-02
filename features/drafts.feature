@javascript
Feature: Drafts

  Background:
    Given I'm logged in
    And I have an activity

  Scenario: View video draft
    Given I have a video draft
    When I browse drafts
    Then my video draft is listed
