//
//  GameSummary.swift
//  Standford Course 2025
//
//  Created by visortix on 30.12.2025.
//

import SwiftUI

struct GameSummary: View {
    // MARK: Data In
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title2)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempts](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummary(game: CodeBreaker())
    }
    List {
        GameSummary(game: CodeBreaker())
    }
    .listStyle(.plain)
}
