//
//  MatchMarkers.swift
//  Standford Course 2025
//
//  Created by visortix on 26.11.2025.
//


import SwiftUI

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    let matches: [Match]
    
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
            VStack {
                matchMarker(peg: 4)
                matchMarker(peg: 5)
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count(where: {match in match == .exact})
        let foundCount = matches.count(where: {match in match != .nomatch})
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

struct MatchMarkersPreview: View {
    let matches: [Match]

    var body: some View {
        HStack {
            ForEach(0..<matches.count, id: \.self) { i in
                Circle()
            }
            MatchMarkers(matches: matches)
        }
        .frame(width: 350, height: 40, alignment: .leading)

        .padding()
    }
}

#Preview {
    MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact, .exact, .exact])
    MatchMarkersPreview(matches: [.inexact, .inexact, .nomatch])
    MatchMarkersPreview(matches: [.exact, .inexact, .exact, .exact])
    MatchMarkersPreview(matches: [.exact, .exact, .exact, .exact, .exact, .exact])
}
