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
    // MARK: Data In
    let matches: [Match]
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            let slots = max(matches.count, 3)
            
            ForEach(0..<slots, id: \.self) { i in
                if i % 2 == 0 {
                    VStack {
                        matchMarker(peg: i)
                        matchMarker(peg: i + 1)
                    }
                }
            }
        }
    }
    
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.filter { $0 == .exact }.count
        let foundCount = matches.filter { $0 != .nomatch }.count
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .exact, .exact])
}
