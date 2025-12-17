//
//  CodeView.swift
//  Standford Course 2025
//
//  Created by visortix on 11.12.2025.
//

import SwiftUI

struct CodeView: View {
    // MARK: Data In
    let code: Code
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    // MARK: - Body
    
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index], kind: code.kind)
                .background {
                    if index == selection, code.kind == .guess {
                        GeometryReader { proxy in
                            let height = proxy.size.height
                            Circle()
                                .offset(y: height * 4.7)
                                .scaleEffect(0.13)
                        }
                    }
                }
                .overlay {
                    Circle().scale(1.15)
                        .foregroundStyle(code.isHidden ? Color.gray(0.97) : .clear)
                }
                .contentShape(Rectangle())
                .accessibilityElement(children: .ignore)
                .accessibilityIdentifier(code.kind == .guess ? "guess_peg_slot_\(index)" : "static_peg")
                .accessibilityAddTraits(.isButton)
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(code.pegs[index].accessibilityLabel)
                .accessibilityAddTraits(code.kind == .guess ? .isButton : .isImage)
        }
    }
}

//#Preview {
//    CodeView()
//}
