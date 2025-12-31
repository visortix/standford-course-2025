//
//  GameChooser.swift
//  Standford Course 2025
//
//  Created by visortix on 30.12.2025.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(games) { game in
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.pegs) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in
                    games.remove(atOffsets: offsets)
                }
                .onMove { offsets, destination in
                    games.move(fromOffsets: offsets, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Peg].self) { pegs in
                PegChooser(choices: pegs)
            }
            .listStyle(.plain)
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.color(.red), .color(.blue), .color(.green), .color(.yellow)]))
            games.append(CodeBreaker(name: "Wild World", pegChoices: [.emoji("🐶"), .emoji("🐱"), .emoji("🐹"), .emoji("🐰")]))
            games.append(CodeBreaker())
        }
    }
}
                      
#Preview {
    GameChooser()
}
