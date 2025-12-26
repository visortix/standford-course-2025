//
//  UIExtensions.swift
//  Standford Course 2025
//
//  Created by visortix on 26.12.2025.
//

import SwiftUI

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = codeBreaker
    static let restart = codeBreaker
    static let selection = codeBreaker
}

extension AnyTransition {
    static let pegChooser = AnyTransition.offset(y: 120)
    static func attempt(_ isOver: Bool) -> AnyTransition {
        .asymmetric(
            insertion: isOver ? .identity : .move(edge: .top),
            removal: .move(edge: .trailing)
        )
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 12/360, saturation: 0, brightness: brightness)
    }
}

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}
