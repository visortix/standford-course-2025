//
//  Standford_Course_2025UITests.swift
//  Standford Course 2025UITests
//
//  Created by visortix on 26.11.2025.
//

//
//  CodeBreakerLoadTests.swift
//  Standford Course 2025 UITests
//
//  Created by Automation on 16.12.2025.
//

import XCTest

final class CodeBreakerLoadTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// TC-01: Peg Selection
    func testPegSelection() {
        // Записані дії
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["guess_peg_slot_0"]/*[[".otherElements.buttons[\"guess_peg_slot_0\"]",".buttons[\"guess_peg_slot_0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_0"]/*[[".otherElements",".buttons[\"😎\"]",".buttons[\"peg_option_0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
    }
    
    /// TC-02: Submit Guess
    func testSubmitGuess() {
        // Записані дії
        let app = XCUIApplication()
        app.activate()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_0"]/*[[".otherElements",".buttons[\"😎\"]",".buttons[\"peg_option_0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_5"]/*[[".otherElements",".buttons[\"😡\"]",".buttons[\"peg_option_5\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_2"]/*[[".otherElements",".buttons[\"👽\"]",".buttons[\"peg_option_2\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_3"]/*[[".otherElements",".buttons[\"😈\"]",".buttons[\"peg_option_3\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_4"]/*[[".otherElements",".buttons[\"🥶\"]",".buttons[\"peg_option_4\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["peg_option_1"]/*[[".otherElements",".buttons[\"🤗\"]",".buttons[\"peg_option_1\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Guess"]/*[[".otherElements.buttons[\"Guess\"]",".buttons[\"Guess\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        // Власна перевірка
        let attemptsList = app.scrollViews.firstMatch
        XCTAssertTrue(attemptsList.exists)
    }
}
