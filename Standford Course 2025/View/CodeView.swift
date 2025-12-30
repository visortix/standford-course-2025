//
//  CodeView.swift
//  Standford Course 2025
//
//  Created by visortix on 11.12.2025.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    // MARK: Data In
    let code: Code
    @ViewBuilder let ancillaryView: () -> AncillaryView
    
    // MARK: Data Shared with Me
    @Binding var selection: Int
    
    
    
    init(code: Code,
         selection: Binding<Int> = .constant(-1),
         @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }
    ) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }
    
    // MARK: Data Owned by Me
    @Namespace private var selectionNamespace
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            pegs
            matchMarkers
        }
    }
    
    var pegs: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index], kind: code.kind)
                .background { /// - selection dot
                    Group {
                        if index == selection, code.kind == .guess {
                            GeometryReader { proxy in
                                let height = proxy.size.height
                                Circle()
                                    .offset(y: height * 4.7)
                                    .scaleEffect(0.13)
                                    
                            }
                            .matchedGeometryEffect(id: "selection", in: selectionNamespace)
                        }
                    }
                    .animation(.selection, value: selection)
                }
                .overlay { /// - hiden code obscuring
                    Circle().scale(1.15)
                        .foregroundStyle(code.isHidden ? Color.gray(0.97) : .clear)
                        .transaction { transaction in
                            if code.isHidden {
                                transaction.animation = nil
                            }
                        }
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    var matchMarkers: some View {
        Rectangle().foregroundStyle(.clear).aspectRatio(1, contentMode: .fit)
            .overlay {
                ancillaryView()
            }
    }
}

//#Preview {
//    CodeView()
//}
