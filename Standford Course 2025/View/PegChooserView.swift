//
//  PegChooserView.swift
//  Standford Course 2025
//
//  Created by visortix on 11.12.2025.
//

import SwiftUI

struct PegChooserView: View {
    let choices: [Peg]
    let onChoose: ((Peg) -> Void)?
    
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
