//
//  PegView.swift
//  Standford Course 2025
//
//  Created by visortix on 11.12.2025.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    let kind: Code.Kind
    
    init(peg: Peg, kind: Code.Kind = .unknown) {
        self.peg = peg
        self.kind = kind
    }
    
    // MARK: - Body
    
    let shape = Circle()

    var body: some View {
        shape.foregroundStyle(.clear).aspectRatio(1, contentMode: .fit)
            .contentShape(shape)
            .overlay {
                if kind == .guess {
                    shape.strokeBorder(.gray)
                }
                pegContent
            }
    }
    
    @ViewBuilder
    var pegContent: some View {
        switch peg {
        case .emoji(let emojiString):
            Text(emojiString)
                .font(.system(size: 80))
                .minimumScaleFactor(0.1)
        case .color(let pegColor):
            shape.fill(pegColor)
        default:
            shape.fill(.clear)
        }
    }
}

//#Preview {
//    PegView()
//}
