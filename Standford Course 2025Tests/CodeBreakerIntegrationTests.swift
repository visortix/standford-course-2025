//
//  CodeBreakerIntegrationTests.swift
//  Standford Course 2025
//
//  Created by visortix on 13.12.2025.
//

import XCTest
import SwiftUI
@testable import Standford_Course_2025

final class CodeBreakerIntegrationTests: XCTestCase {

    var game: CodeBreaker!

    // MARK: - Налаштування середовища (Setup)
    
    override func setUpWithError() throws {
        // Ініціалізуємо гру перед кожним тестом.
        // Встановлюємо фіксовану довжину коду (4), щоб спростити перевірки.
        game = CodeBreaker(count: 4)
    }

    override func tearDownWithError() throws {
        game = nil
    }

    // MARK: - Тест-кейс №1: Перевірка логіки "Часткового співпадіння"
    // Мета: Перевірити інтеграцію між CodeBreaker (збереження ходу) та Code (алгоритм match).
    // Сценарій: Користувач вгадує 2 кольори точно і 2 кольори не на своїх місцях.
    
    func testPartialMatchIntegration() throws {
        // 1. Arrange (Підготовка даних)
        // Примусово встановлюємо "Секретний код" (Master Code), щоб тест був детермінованим.
        // Master: [🔴, 🟢, 🔵, 🟡]
        var fixedMaster = Code(kind: .master(isHidden: true), count: 4)
        let red = Peg.color(.red)
        let green = Peg.color(.green)
        let blue = Peg.color(.blue)
        let yellow = Peg.color(.yellow)
        
        fixedMaster.pegs = [red, green, blue, yellow]
        game.masterCode = fixedMaster
        
        // Формуємо спробу користувача (Guess).
        // Guess: [🔴, 🟢, 🟡, 🔵] -> (Red і Green на місці, Blue і Yellow переплутані)
        game.setGuessPeg(red, at: 0)    // Правильно
        game.setGuessPeg(green, at: 1)  // Правильно
        game.setGuessPeg(yellow, at: 2) // Неправильне місце (має бути Blue)
        game.setGuessPeg(blue, at: 3)   // Неправильне місце (має бути Yellow)
        
        // 2. Act (Виконання дії)
        // Викликаємо метод, який запускає взаємодію компонентів
        game.attemptGuess()
        
        // 3. Assert (Перевірка результатів)
        
        // А. Перевіряємо, чи CodeBreaker успішно додав спробу в масив attempts
        XCTAssertEqual(game.attempts.count, 1, "Масив спроб має містити 1 елемент")
        
        // Б. Перевіряємо, чи правильно Code розрахував matches і повернув їх у CodeBreaker
        let lastAttempt = game.attempts.last!
        let matches = lastAttempt.matches!
        
        // Очікуємо: 2 .exact (червоний, зелений) та 2 .inexact (жовтий, синій)
        let exactMatches = matches.filter { $0 == .exact }.count
        let inexactMatches = matches.filter { $0 == .inexact }.count
        
        XCTAssertEqual(exactMatches, 2, "Має бути 2 точних співпадіння")
        XCTAssertEqual(inexactMatches, 2, "Має бути 2 неточних співпадіння")
        
        // В. Перевіряємо, що статус гри не змінився на "Завершено"
        XCTAssertFalse(game.isOver, "Гра не повинна завершитись, оскільки код не вгадано повністю")
    }

    // MARK: - Тест-кейс №2: Перевірка умови перемоги (End-to-End сценарій)
    // Мета: Перевірити, як система реагує на повне співпадіння (взаємодія Code -> CodeBreaker state).
    
    func testWinningConditionIntegration() throws {
        // 1. Arrange
        // Master: [🟣, 🟣, 🟣, 🟣]
        var fixedMaster = Code(kind: .master(isHidden: true), count: 4)
        let purple = Peg.color(.purple)
        fixedMaster.pegs = [purple, purple, purple, purple]
        game.masterCode = fixedMaster
        
        // 2. Act
        // Вводимо абсолютно правильну комбінацію
        for i in 0..<4 {
            game.setGuessPeg(purple, at: i)
        }
        game.attemptGuess()
        
        // 3. Assert
        
        // Перевіряємо, чи CodeBreaker отримав сигнал про перемогу
        XCTAssertTrue(game.isOver, "Властивість isOver має стати true після правильної здогадки")
        
        // Перевіряємо "Побічний ефект" перемоги: Master Code має відкритися
        // Це підтверджує, що логіка всередині attemptGuess спрацювала до кінця
        if case .master(let isHidden) = game.masterCode.kind {
            XCTAssertFalse(isHidden, "Master code має стати видимим (isHidden = false) після перемоги")
        } else {
            XCTFail("Тип masterCode змінився на некоректний")
        }
    }
    
    // MARK: - Тест-кейс №3: Валідація неповної спроби
    // Мета: Перевірити захисний механізм. CodeBreaker НЕ повинен викликати логіку Code, якщо даних недостатньо.
    
    func testIncompleteGuessIntegration() {
        // 1. Arrange
        let red = Peg.color(.red)
        
        // 2. Act
        game.attemptGuess()
        
        // 3. Assert
        // Спроба не має бути записана
        XCTAssertEqual(game.attempts.count, 0, "Спроба не повинна бути додана, якщо код неповний")
        
        // Стан гри не має змінитись
        XCTAssertFalse(game.isOver)
    }
}
// MARK: - Spy Object Implementation
// Цей клас існує лише всередині тестового файлу.
// Він "шпигує" за викликами, записуючи їх, замість того щоб писати в реальну базу.

class SpyScoreSaver: ScoreSaver {
    // Прапорець: чи був викликаний метод?
    var saveScoreCalled: Bool = false
    
    // Дані: яке саме значення намагалися зберегти?
    var lastSavedScore: Int?
    
    func saveBestScore(attempts: Int) {
        saveScoreCalled = true
        lastSavedScore = attempts
        print("Spy зафіксував виклик збереження з результатом: \(attempts)")
    }
}

// MARK: - Інтеграційний тест з використанням Spy

extension CodeBreakerIntegrationTests {
    
    func testScoreSavingInteraction() {
        // 1. ARRANGE (Підготовка)
        // Створюємо шпигуна
        let spy = SpyScoreSaver()
        
        // Впроваджуємо шпигуна в гру (Dependency Injection)
        var gameWithSpy = CodeBreaker(count: 4, scoreSaver: spy)
        
        // Налаштовуємо гру для швидкої перемоги
        var fixedMaster = Code(kind: .master(isHidden: true), count: 4)
        let winPeg = Peg.color(.green)
        fixedMaster.pegs = [winPeg, winPeg, winPeg, winPeg]
        gameWithSpy.masterCode = fixedMaster
        
        // 2. ACT (Дія)
        // Робимо виграшний хід
        for i in 0..<4 {
            gameWithSpy.setGuessPeg(winPeg, at: i)
        }
        
        // Цей метод має викликати spy.saveBestScore() всередині, якщо логіка вірна
        gameWithSpy.attemptGuess()
        
        // 3. ASSERT (Перевірка взаємодії)
        
        // Перевіряємо факт виклику (Behavior Verification)
        XCTAssertTrue(spy.saveScoreCalled, "Метод збереження мав бути викликаний після перемоги")
        
        // Перевіряємо передані аргументи (State Verification)
        XCTAssertEqual(spy.lastSavedScore, 1, "Система мала спробувати зберегти рахунок '1' (одна спроба)")
    }
}
