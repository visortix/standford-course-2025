//
//  CucumberishLoader.swift
//  Standford Course 2025
//
//  Created by visortix on 15.12.2025.
//

import Foundation
import Cucumberish

class CucumberishLoader: NSObject {
    
    @objc class func CucumberishInit() {
        // 1. Тут ініціалізуємо ваші кроки (Steps)
        // Припустимо, у вас є клас CodeBreakerSteps із методом setup()
        // CodeBreakerSteps().setup()
        // (Або пропишіть кроки прямо тут для тесту)
        
        // Приклад простого кроку для перевірки:
        Given("the app is running") { _ in
            XCUIApplication().launch()
        }
        
        // 2. Налаштування Cucumberish
        let bundle = Bundle(for: CucumberishLoader.self)
        
        // Вказуємо папку, де лежать .feature файли
        // (Їх треба буде створити, див. Крок 4)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: nil)
    }
}
