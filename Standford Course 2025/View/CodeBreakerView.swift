//
//  CodeBreakerView.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//

import SwiftUI
import CoreData

struct CodeBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker
    
    // MARK: Data Owned by Me
    @State private var selection: Int = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
            
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            .opacity(restarting ? 0 : 1)
            .animation(nil, value: game.masterCode.pegs)
            .animation(nil, value: restarting)
            Divider()
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) { guessButton }
                        .padding(GuessLine.padding)
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code:  attempt) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver {
                Group {
                    Divider()
                    PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                }
                .transition(.pegChooser)
            }
        }
        .toolbar {
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                    .monospacedDigit()
                    .fixedSize()
            }
            ToolbarItem(placement: .primaryAction) {
                restartButton.labelStyle(.titleOnly)
            }
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.pegCount
    }
    
    // MARK: - Buttons
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation(.guess) {
                game.attemptGuess()
                selection = 0
                hideMostRecentMarkers = true
            } completion: {
                withAnimation(.guess) {
                    hideMostRecentMarkers = false
                }
            }
        }
        .flexibleSystemFont()
    }
    
    var restartButton: some View {
        Button("Restart", systemImage: "arrow.circlepath") {
            withAnimation(.restart) {
                restarting = game.isOver
                game.restart()
                selection = 0
            } completion: {
                withAnimation(.restart) {
                    restarting = false
                }
            }
        }
    }
    
    // MARK: - Constants

    struct GuessLine {
        static let bottomBorder: CGFloat = 15
        static let padding = EdgeInsets(top: 0, leading: 0, bottom: GuessLine.bottomBorder, trailing: 0)
    }
}


// MARK: - #Preview

#Preview {
    @Previewable @State var game = CodeBreaker()
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
