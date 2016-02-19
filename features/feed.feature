Feature: See videos in my feed

  Scenario: New edit
    Given I have an edit
    And I'm logged in
    When I visit my feed
    Then I should see a new edit
