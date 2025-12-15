//
//  Tests.swift
//  Standford Course 2025
//
//  Created by visortix on 15.12.2025.
//

Feature: CodeBreaker Gameplay
  As a player
  I want to guess the secret code
  So that I can win the game and test my logic

  Background:
    Given the CodeBreaker app is launched
    And a new game is started with 4 pegs

  Scenario: Initial Game State (Smoke Test)
    Then the Master Code should be hidden
    And the Guess Row should be empty
    And the "Guess" button should not be visible initially

  Scenario: Making a Valid Guess
    Given I have selected "🔴" for position 1
    And I have selected "🟢" for position 2
    And I have selected "🔵" for position 3
    And I have selected "🟡" for position 4
    When I tap the "Guess" button
    Then a new attempt should appear in the history list
    And the Guess Row should be reset

  Scenario: Winning the Game
    Given the secret Master Code is "🔴, 🟢, 🔵, 🟡"
    When I select the sequence "🔴, 🟢, 🔵, 🟡"
    And I tap the "Guess" button
    Then the Master Code should be revealed
    And the "Restart Game" button should be visible
