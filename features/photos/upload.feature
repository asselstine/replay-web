Feature: Upload photos to site

  Background:
    Given I'm logged in
    And I've been somewhere

  Scenario: Upload a photo without geo info
    When I upload a photo without geo info where I've been
    And I go to my uploaded photos
    Then I should see a photo

  Scenario: Upload a photo with geo info
    When I upload a photo with geo info
    And I go to my uploaded photos
    Then I should see a photo
    And I should see the geo info
