//
//  ContentView.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(colors: [.red, .blue, .yellow])
            pegs(colors: [.red, .blue, .yellow])
            pegs(colors: [.red, .blue, .yellow])
        }
        .padding()
    }
    
    func pegs(colors: [Color]) -> some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                RoundedRectangle(cornerRadius: 10)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundStyle(color)
            }
            MatchMarkers(matches: [.exact, .nomatch, .inexact, .nomatch])
        }
    }
}



#Preview {
    ContentView()
}
