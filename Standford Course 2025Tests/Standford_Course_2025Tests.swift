//
//  Standford_Course_2025_Tests.swift
//  Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import XCTest
import SwiftUI
@testable import Standford_Course_2025

final class Standford_Course_2025Tests: XCTestCase {

    // MARK: - 1. Тести для алгоритму Match (Code.swift)
    
    func testMatchExact() {
        // Given (Дано)
        // Створюємо два однакові коди: [🔴, 🟢, 🔵]
        let red = Peg.color(.red)
        let green = Peg.color(.green)
        let blue = Peg.color(.blue)
        
        var master = Code(kind: .master(isHidden: true), count: 3)
        master.pegs = [red, green, blue]
        
        var guess = Code(kind: .guess, count: 3)
        guess.pegs = [red, green, blue]
        
        // When (Коли)
        let results = guess.match(against: master)
        
        // Then (Тоді)
        // Очікуємо 3 точних співпадіння
        XCTAssertEqual(results, [.exact, .exact, .exact], "Ідентичні коди повинні давати всі .exact")
    }
    
    func testMatchDuplicateHandling() {
        // Given (Складний випадок з дублікатами)
        // Master: [🔴, 🟢, 🔵]
        // Guess:  [🔴, 🔴, 🟡]
        // Очікування: Перший червоний -> .exact. Другий червоний -> .nomatch (бо єдиний червоний в майстер-коді вже зайнятий першим).
        let red = Peg.color(.red)
        let green = Peg.color(.green)
        let blue = Peg.color(.blue)
        let yellow = Peg.color(.yellow)
        
        var master = Code(kind: .master(isHidden: true), count: 3)
        master.pegs = [red, green, blue]
        
        var guess = Code(kind: .guess, count: 3)
        guess.pegs = [red, red, yellow]
        
        // When
        let results = guess.match(against: master)
        
        // Then
        XCTAssertEqual(results[0], .exact, "Перший елемент на своєму місці")
        XCTAssertEqual(results[1], .nomatch, "Другий елемент дублює колір, який вже використано для exact match")
        XCTAssertEqual(results[2], .nomatch, "Жовтого взагалі немає в коді")
    }

    // MARK: - 2. Тести для логіки гри (CodeBreaker.swift)
    
    func testAttemptGuessBlockMissingPegs() {
        // Given
        var game = CodeBreaker(count: 3)
        // Робимо "дірявий" код: [🔴, missing, 🔵]
        game.guess.pegs[0] = .missing
        game.guess.pegs[1] = .missing
        game.guess.pegs[2] = .missing
        
        let initialAttemptsCount = game.attempts.count
        
        // When
        game.attemptGuess()
        
        // Then
        XCTAssertEqual(game.attempts.count, initialAttemptsCount, "Спроба не має зараховуватись, якщо є missing pegs")
    }
    
    func testAttemptGuessSuccess() {
        // Given
        var game = CodeBreaker(count: 3)
        // Заповнюємо всі фішки
        game.guess.pegs = [.color(.red), .color(.red), .color(.red)]
        
        // When
        game.attemptGuess()
        
        // Then
        XCTAssertEqual(game.attempts.count, 1, "Валідна спроба має бути додана до масиву attempts")
        XCTAssertTrue(game.guess.pegs.allSatisfy({ $0 == .missing }), "Після ходу поле вводу має очиститись (стати missing)")
    }
    
    // MARK: - 3. Тести для зміни фішок (CodeBreaker.swift)
    
    func testCyclePegs() {
        // Given
        // Припустимо, що pegChoices = [.red, .green, .yellow ...]
        // Створимо гру з фіксованими кольорами для передбачуваності
        let choices: [Peg] = [.color(.red), .color(.green)]
        var game = CodeBreaker(pegChoices: choices, count: 2, gameNumber: 0)
        
        // Встановлюємо першу фішку як Red
        game.setGuessPeg(choices[0], at: 0) // Red
        
        // When: міняємо фішку
        game.changeGuessPeg(at: 0)
        
        // Then: має стати Green
        XCTAssertEqual(game.guess.pegs[0], choices[1], "Фішка має змінитися на наступну (Green)")
        
        // When: міняємо ще раз
        game.changeGuessPeg(at: 0)
        
        // Then: має зациклитись і знову стати Red
        XCTAssertEqual(game.guess.pegs[0], choices[0], "Фішка має повернутися на початок списку (Red)")
    }
}
