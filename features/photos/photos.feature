Feature: View photos

  Background:
    Given I'm logged in

  Scenario: View my photos
    Given I've been somewhere
    And there was a photo taken near my location
    When my account is synchronized
    And I go to my photos
    Then I should see a photo

  Scenario: Only my photos
    Given I've been somewhere
    And there was a photo taken on the other side of the world
    When my account is synchronized
    And I go to my photos
    Then I should not see any photos
