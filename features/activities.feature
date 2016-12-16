@javascript
Feature: Browse activities

  Scenario: Browse video drafts
    Given I have a segment effort
    When I log in
    And I browse activities
    Then I can see the activity
    And I can see the segment effort
