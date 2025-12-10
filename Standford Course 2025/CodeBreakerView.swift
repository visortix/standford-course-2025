//
//  CodeBreakerView.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//

import SwiftUI
import CoreData



struct CodeBreakerView: View {
    @State private var game = CodeBreaker()
            
    var body: some View {
        VStack {
            line(of: game.masterCode)
            Divider()
            ScrollView {
                line(of: game.guess)
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    line(of: game.attempts[index])
                }
            }
        }
        .padding()
    }
    
    // MARK: - Buttons
    
    var guessButton: some View {
        Button("Guess") {
            withAnimation {
                game.attemptGuess()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    var restartButton: some View {
        Button("Restart Game") {
            withAnimation {
                game.restartGame()
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
    }
    
    
    // MARK: - Code line views
    
    @ViewBuilder
    func draw(peg: Peg, using roundedRectangle: RoundedRectangle) -> some View {
        switch peg {
        case .emoji(let emojiString):
            Text(emojiString)
                .font(.system(size: 80))
                .minimumScaleFactor(0.1)
        case .color(let pegColor):
            roundedRectangle.fill(pegColor)
        default:
            roundedRectangle.fill(.clear)
        }
    }
    
    func drawPegs(from code: Code) -> some View {
        let roundedRectangle = RoundedRectangle(cornerRadius: 10)

        return ForEach(code.pegs.indices, id: \.self) { index in
            let peg = code.pegs[index]
            
            ZStack {
                roundedRectangle.foregroundStyle(.clear).aspectRatio(1, contentMode: .fit)
                    .overlay {
                        if code.kind == .guess {
                            roundedRectangle.strokeBorder(.gray)
                        }
                        draw(peg: peg, using: roundedRectangle)
                    }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if code.kind == .guess {
                    game.changeGuessPeg(at: index)
                }
            }
        }
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
                    if code.kind == .master {
                        restartButton
                    }
                }
            }
    }
    
    func line(of code: Code) -> some View {
        HStack {
            drawPegs(from: code)
            matchMarkers(from: code)
        }
    }
}

// MARK: - #Preview

#Preview {
    CodeBreakerView()
}
