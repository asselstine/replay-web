@javascript
Feature: Drafts

  Scenario: Browse video drafts
    Given I have a video draft
    When I log in
    And I browse drafts
    Then my video draft is listed
    When I click on the video draft
    Then I should be able to play the video draft

  Scenario: Video upload triggers video drafting
    Given I have a segment effort
    And I have a video upload
    And there is a setup
    And the video upload belongs to the setup
    When I log in
    And the video upload is updated with the effort timestamp
    And I browse drafts
    Then I can see a video draft
    And I can see the segment effort

  Scenario: New activity triggers video drafting
    Given I have a video upload
    And there is a setup
    And the video upload belongs to the setup
    And the video upload has timestamps
    When I have an activity matching the video upload
    And I have a segment effort
    When I log in
    And I browse drafts
    Then I can see a video draft
    And I can see the segment effort
