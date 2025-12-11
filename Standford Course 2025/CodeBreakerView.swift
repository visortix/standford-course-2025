//
//  CodeBreakerView.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//

import SwiftUI
import CoreData

struct CodeBreakerView: View {
    //MARK: Data Owned by Me
    @State private var game = CodeBreaker()
    @State private var selection: Int = 0
    
    // MARK: - Body
            
    var body: some View {
        VStack {
            line(of: game.masterCode)
            Divider()
            ScrollView {
                if !game.isOver {
                    line(of: game.guess).padding(GuessLine.padding)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    line(of: game.attempts[index])
                }
            }
            PegChooserView(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.pegCount
            }
        }
        .padding()
    }
    
    // MARK: - Buttons
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        }
        .font(.system(size: ActionButton.maximumFontSize))
        .minimumScaleFactor(ActionButton.scaleFactor)
    }
    
    var restartButton: some View {
        Button("Restart Game") {
            withAnimation {
                game.restartGame()
                selection = 0
            }
        }
        .font(.system(size: ActionButton.maximumFontSize))
        .minimumScaleFactor(ActionButton.scaleFactor)
    }
    
    // MARK: - Code Line
    
    func line(of code: Code) -> some View {
        HStack {
            drawPegs(from: code)
            matchMarkers(from: code)
        }
    }
    
    func drawPegs(from code: Code) -> some View {
        CodeView(code: code, selection: $selection)
    }
    
    func matchMarkers(from code: Code) -> some View {
        Rectangle().foregroundStyle(.clear).aspectRatio(1, contentMode: .fit)
            .overlay {
                if let matches = code.matches {
                    MatchMarkers(matches: matches)
                } else {
                    if code.kind == .guess {
                        guessButton
                    }
                    if code.kind == .master(isHidden: false) {
                        restartButton
                    }
                }
            }
    }
    struct ActionButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    struct GuessLine {
        static let bottomBorder: CGFloat = 15
        static let padding = EdgeInsets(top: 0, leading: 0, bottom: GuessLine.bottomBorder, trailing: 0)
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 12/360, saturation: 0, brightness: brightness)
    }
}

// MARK: - #Preview

#Preview {
    CodeBreakerView()
}
