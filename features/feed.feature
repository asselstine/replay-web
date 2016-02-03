Feature: See videos in my feed

  Background:
    Given I've been on a ride
    And I'm logged in

  Scenario: New video
    Given there was video recorded on my ride
    When I visit my feed
    Then I should see a new edit
