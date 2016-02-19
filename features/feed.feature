Feature: See videos in my feed

  Scenario: New video
    Given I've been on a ride
    And there was video recorded on my ride
    And I'm logged in
    When I visit my feed
    Then I should see a new edit
