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
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
            
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) { restartButton.labelStyle(.titleOnly) }
                .opacity(restarting ? 0 : 1)
                .animation(nil, value: game.masterCode.pegs)
            Divider()
            ScrollView {
                if !game.isOver || restarting {
                    CodeView(code: game.guess, selection: $selection) { guessButton }
                        .padding(GuessLine.padding)
                        .animation(nil, value: game.attempts.count)
                        .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code:  game.attempts[index]) {
                        let showMarkers = !hideMostRecentMarkers || index != game.attempts.count - 1
                        if showMarkers, let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            if !game.isOver {
                Group {
                    Divider()
                    PegChooserView(choices: game.pegChoices, onChoose: changePegAtSelection)
                }
                .transition(.pegChooser)
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
        Button("Restart Game", systemImage: "arrow.circlepath") {
            withAnimation(.restart) {
                restarting = true
            } completion: {
                withAnimation(.restart) {
                    game.restart()
                    selection = 0
                    restarting = false
                }
                withAnimation(.restart) {
                    game.restart()
                    selection = 0
                    restarting = false
                }
            }
        }
        .flexibleSystemFont()
    }
    
    // MARK: - Constants

    struct GuessLine {
        static let bottomBorder: CGFloat = 15
        static let padding = EdgeInsets(top: 0, leading: 0, bottom: GuessLine.bottomBorder, trailing: 0)
    }
}


// MARK: - #Preview

#Preview {
    CodeBreakerView()
}
