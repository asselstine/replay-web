Feature: Users creates a recording session

  Background: 
    Given I'm logged in 

  Scenario: Create a new recording session
    When I create a new recording session 
    Then a new recording session should exist

  Scenario: List my recording sessions
    Given I have created a recording session
    When I go to my recording sessions
    Then I should see my existing recording session
