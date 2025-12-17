////
////  Standford_Course_2025UITests.swift
////  Standford Course 2025UITests
////
////  Created by visortix on 26.11.2025.
////
//
////
////  CodeBreakerLoadTests.swift
////  Standford Course 2025 UITests
////
////  Created by Automation on 16.12.2025.
////
//
//import XCTest
//
//final class CodeBreakerLoadTests: XCTestCase {
//
//    var app: XCUIApplication!
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app = XCUIApplication()
//        app.launch()
//    }
//
//    /// Сценарій TC-03: "Швидка реакція UI" (Rapid Interaction)
//    func testRapidSelectionPerformance() {
//        // Знаходимо слоти за нашими новими ID
//        let firstSlot = app.descendants(matching: .any)["guess_peg_slot_0"]
//        let secondSlot = app.descendants(matching: .any)["guess_peg_slot_1"]
//        
//        // Перевіряємо, чи вони існують, перед початком замірів
//        XCTAssertTrue(firstSlot.waitForExistence(timeout: 2), "Слот 0 не знайдено")
//        
//        measure {
//            // Імітуємо дуже швидке перемикання користувача між слотами
//            for _ in 0..<10 {
//                firstSlot.tap()
//                secondSlot.tap()
//            }
//        }
//    }
//    
//    /// Сценарій TC-01: Стрес-тест скролінгу (повний цикл)
//    func testGamePlayAndScrollPerformance() {
//        // Шукаємо елементи будь-якого типу за ID
//        let guessButton = app.buttons["Guess"]
//        let restartButton = app.descendants(matching: .any)["restartButton"]
//        let firstOption = app.descendants(matching: .any)["peg_option_0"]
//        
//        // Обробка попереднього стану (якщо гра вже виграна)
//        if restartButton.exists {
//            restartButton.tap()
//        }
//        
//        // Чекаємо появи кнопки Guess (до 5 секунд)
//        guard guessButton.waitForExistence(timeout: 5) else {
//            print(app.debugDescription) // Для дебагу
//            XCTFail("Кнопка 'Guess' не знайдена!")
//            return
//        }
//        
//        let options = XCTMeasureOptions()
//        options.iterationCount = 3
//        
//        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric], options: options) {
//            
//            for _ in 0..<10 {
//                // Перевіряємо, чи кнопка існує перед натисканням (щоб уникнути крашу в середині циклу)
//                if guessButton.exists {
//                    for i in 0..<4 {
//                        let slot = app.descendants(matching: .any)["guess_peg_slot_\(i)"]
//                        if slot.exists {
//                            slot.tap()
//                            // Чекаємо мить, якщо анімація заважає (опціонально)
//                            firstOption.tap()
//                        }
//                    }
//                    guessButton.tap()
//                }
//            }
//            
//            // Скролінг
//            let scrollArea = app.scrollViews.firstMatch
//            if scrollArea.exists {
//                scrollArea.swipeUp(velocity: .fast)
//                scrollArea.swipeUp(velocity: .fast)
//                scrollArea.swipeUp(velocity: .fast)
//                scrollArea.swipeUp(velocity: .fast)
//                scrollArea.swipeUp(velocity: .fast)
//                scrollArea.swipeDown(velocity: .fast)
//                scrollArea.swipeDown(velocity: .fast)
//                scrollArea.swipeDown(velocity: .fast)
//                scrollArea.swipeDown(velocity: .fast)
//                scrollArea.swipeDown(velocity: .fast)
//            }
//        }
//    }
//}
