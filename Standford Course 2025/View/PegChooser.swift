//
//  PegChooser.swift
//  Standford Course 2025
//
//  Created by visortix on 11.12.2025.
//

import SwiftUI

struct PegChooser: View {
    // MARK: Data In
    let choices: [Peg]
    
    // MARK: Data Out Function
    let onChoose: ((Peg) -> Void)?
    
    init(choices: [Peg], onChoose: ((Peg) -> Void)? = nil) {
        self.choices = choices
        self.onChoose = onChoose
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(choices.enumerated(), id: \.element) { (index, peg) in
                Button {
                    onChoose?(peg)
                } label: {
                    PegView(peg: peg)
                }
                .accessibilityIdentifier("peg_option_\(index)")
            }
        }
    }
}

//#Preview {
//    PegChooserView()
//}
