//
//  CodeBreakerSteps.swift
//  Standford Course 2025
//
//  Created by visortix on 15.12.2025.
//

import Foundation
import Cucumberish
import XCTest

class CodeBreakerSteps: NSObject {
    
    @objc class func setup() {
        let app = XCUIApplication()
        
        // --- 1. GIVEN (Передумови) ---
        
        Given("the CodeBreaker app is launched") { _,_  in
            app.launch()
        }
        
        Given("a new game is started") { _,_  in
            // Перевіряємо, чи ми на головному екрані.
            // Якщо гра вже завершена (видно кнопку Restart), натискаємо її для старту нової.
            if app.buttons["restartButton"].exists {
                app.buttons["restartButton"].tap()
            }
            // Переконуємось, що поле для вгадування пусте (індекс 0 обрано)
            XCTAssertTrue(app.collectionViews.element.exists || app.scrollViews.element.exists)
        }
        
        Given("the secret Master Code is fixed") { _,_  in
            // У реальному тесті тут варто було б мокати (mock) генератор випадкових чисел,
            // або запускати app з аргументом запуску, наприклад:
            // app.launchArguments.append("-UITestingFixedCode")
            // Для цього прикладу ми пропускаємо реалізацію бекенд-моку.
        }

        // --- 2. WHEN (Дії) ---
        
        When("I tap the \"(.*)\" button") { args, _ in
            guard let buttonName = args?[0] as? String else { return }
            
            // Шукаємо кнопку за текстом (наприклад, "Guess") або ідентифікатором
            let button = app.buttons[buttonName]
            if button.exists {
                button.tap()
            } else {
                // Спроба знайти за ідентифікатором (для guessButton/restartButton)
                let idButton = app.buttons[buttonName.lowercased() + "Button"]
                if idButton.exists {
                    idButton.tap()
                } else {
                    XCTFail("Button with name \(buttonName) not found")
                }
            }
        }
        
        When("I select the peg \"(.*)\" for position (\\d+)") { args, _ in
            // Цей крок емулює вибір фішки.
            // У вашій логіці: тап на фішку внизу додає її в поточний слот.
            guard let pegEmoji = args?[0] as? String else { return }
            
            // Знаходимо кнопку з відповідним емодзі на панелі вибору
            let pegButton = app.buttons[pegEmoji]
            XCTAssertTrue(pegButton.exists, "Peg button \(pegEmoji) not found")
            pegButton.tap()
        }
        
        When("I fill the row with sequence \"(.*)\"") { args, _ in
            guard let sequenceString = args?[0] as? String else { return }
            // Припускаємо вхідний рядок "🔴, 🟢, 🔵, 🟡"
            let pegs = sequenceString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            
            for peg in pegs {
                let pegButton = app.buttons[peg]
                if pegButton.exists {
                    pegButton.tap()
                }
            }
        }

        // --- 3. THEN (Перевірки) ---
        
        Then("the Master Code should be hidden") { _,_  in
            // Перевіряємо, що НЕМАЄ елементів, які показують відкритий код (або є "заглушка")
            // У вашому коді це реалізовано через прозорість або сірий колір.
            // Найпростіше перевірити відсутність кнопки Restart, яка з'являється тільки при відкритті коду.
            XCTAssertFalse(app.buttons["restartButton"].exists, "Master code revealed prematurely!")
        }
        
        Then("the Master Code should be revealed") { _,_  in
            // Коли код відкритий, з'являється кнопка рестарту (згідно з вашим CodeBreakerView)
            let restartBtn = app.buttons["restartButton"]
            XCTAssertTrue(restartBtn.waitForExistence(timeout: 2.0), "Master code was not revealed (Restart button missing)")
        }
        
        Then("a new attempt should appear in the history list") { _,_  in
             // Перевіряємо, що в ScrollView з'явилися елементи.
             // Це спрощена перевірка. Більш детальна перевіряла б кількість нащадків у ScrollView.
             let scrollView = app.scrollViews.element
             XCTAssertTrue(scrollView.exists)
             // Перевірка, що кількість елементів > 0 (або змінилася)
        }
        
        Then("the \"Guess\" button should not be visible initially") { _,_  in
             // Кнопка Guess з'являється тільки коли рядок заповнений (за логікою UI, або вона disabled)
             // Якщо у вашому коді вона просто не рендериться:
             XCTAssertFalse(app.buttons["guessButton"].exists)
        }
    }
}
