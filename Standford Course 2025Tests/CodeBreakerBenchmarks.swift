//
//  Standford_Course_2025_Tests.swift
//  Standford Course 2025
//
//  Created by visortix on 12.12.2025.
//

import XCTest
@testable import Standford_Course_2025

final class CodeBreakerBenchmarks: XCTestCase {
    var game: CodeBreaker!

    override func setUp() {
        // Створюємо гру з максимальною кількістю елементів (6) для навантаження
        game = CodeBreaker(count: 6, gameNumber: 2)
    }

    // TC-01 Метрика: Час виконання. Baseline: < 0.001s
    func testAttemptGuessPerformance() {
        // Заповнюємо guess, щоб алгоритм виконував порівняння
        for i in 0..<game.pegCount {
             if let peg = game.pegChoices.first { game.setGuessPeg(peg, at: i) }
        }
        
        measure {
            // Виконуємо 1000 разів для точності вимірювання
            for _ in 0..<1000 {
                var benchmarkGame = game
                benchmarkGame?.attemptGuess()
            }
        }
    }
    
    // TC-02 Метрика: Обсяг виділеної пам'яті (Memory High Watermark)
    func testObjectAllocationLoad() {
        measure(metrics: [XCTMemoryMetric()]) {
            // Створюємо та знищуємо об'єкти гри у циклі
            var tempGame = CodeBreaker(count: 6)
            for _ in 0..<5000 {
                tempGame.guess.randomize(from: tempGame.pegChoices)
                tempGame.attemptGuess()
                // Тут tempGame виходить з області видимості, пам'ять має звільнитися
            }
        }
    }
}
