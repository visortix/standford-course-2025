//
//  CodeBreaker.swift
//  Standford Course 2025
//
//  Created by visortix on 07.12.2025.
//

import SwiftUI
import GameKit
import os

let logger = Logger(subsystem: "com.stanford.codebreaker", category: "GameLogic")
let signposter = OSSignposter(logger: logger)

enum Peg: Equatable, Hashable {
    case color(Color)
    case emoji(String)
    case missing
}

struct CodeBreaker {
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let pegChoices: [Peg]
    
    private static var pegColors: [Peg] = [
        .color(.red),
        .color(.green),
        .color(.yellow),
        .color(.blue),
        .color(.purple),
        .color(.cyan)
    ]

    private static var pegEmojis: [Peg] = [
        .emoji("😎"),
        .emoji("🤗"),
        .emoji("👽"),
        .emoji("😈"),
        .emoji("🥶"),
        .emoji("😡")
    ]
    
    init(
        pegChoices: [Peg] = pegEmojis,
        count: Int? = nil,
        gameNumber: Int = 0
    ) {        
        self.pegChoices = switch gameNumber {
        case 1: CodeBreaker.pegColors
        case 2: CodeBreaker.pegEmojis
        default: pegChoices
        }
        
        let secureCount: Int
        if let requestedCount = count {
            secureCount = requestedCount
        } else {
            secureCount = 3 + GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        }
        
        if !pegChoices.isEmpty {
            switch self.pegChoices[0] {
            case .emoji(_):
                CodeBreaker.pegEmojis = self.pegChoices
            case .color(_):
                CodeBreaker.pegColors = self.pegChoices
            default: break
            }
        }

        masterCode = Code(kind: .master(isHidden: true), count: secureCount)
        masterCode.randomize(from: self.pegChoices)
        guess = Code(kind: .guess, count: secureCount)
    }
    
    var pegCount: Int {
        masterCode.pegs.count
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        let state = signposter.beginInterval("Attempt Guess Logic")
        defer { signposter.endInterval("Attempt Guess Logic", state) }
        
        let missingPegs = guess.pegs.filter({ $0 == Peg.missing })
        guard missingPegs.count != masterCode.pegs.count else { return }
//        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
//            return
//        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard masterCode.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func restartGame() {
        self = CodeBreaker(gameNumber: (1 + GKRandomSource.sharedRandom().nextInt(upperBound: 2)))
    }
    
    mutating func changeGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPeg = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPeg + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
}

