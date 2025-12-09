//
//  CodeBreaker.swift
//  Standford Course 2025
//
//  Created by visortix on 07.12.2025.
//

import SwiftUI

enum Peg: Equatable {
    case color(Color)
    case emoji(String)
    case missing
}

// MARK: - struct CodeBreakers

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
        count: Int = Int.random(in: 3...6),
        gameNumber: Int = 0
    )
    {
        print(gameNumber)
        
        self.pegChoices = switch gameNumber {
        case 1: CodeBreaker.pegColors
        case 2: CodeBreaker.pegEmojis
        default: pegChoices
        }
        
        print(self.pegChoices)

        
        if !pegChoices.isEmpty {
            switch self.pegChoices[0] {
            case .emoji(_):
                CodeBreaker.pegEmojis = self.pegChoices
            case .color(_):
                CodeBreaker.pegColors = self.pegChoices
            default: break
            }
        }

        masterCode = Code(kind: .master, count: count)
        masterCode.randomize(from: self.pegChoices)
        guess = Code(kind: .guess, count: count)
    }
    
    mutating func attemptGuess() {
        let missingPegs = guess.pegs.filter({ $0 == Peg.missing })
        guard missingPegs.count != masterCode.pegs.count else { return }
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        
        attempts.append(attempt)
    }
    
    mutating func restartGame() {
        print("here")
        self = CodeBreaker(gameNumber: Int.random(in: 1...2))
    }
    
    mutating func changeGuessPeg(at index: Int) {
        guard index < guess.pegs.count else { return }
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPeg = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPeg + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
}

// MARK: - struct Code

struct Code {
    var kind: Kind
    var pegs: [Peg]
    
    init(kind: Kind, count: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Peg.missing, count: count)
    }
    
    enum Kind: Equatable {
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
    }
    
    var matches: [Match] {
        switch kind {
        case .attempt(let matches): return matches
        default: return []
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var results: [Match] = Array(repeating: .nomatch, count: pegs.count)
        var pegsToMatch = otherCode.pegs
                
        for index in pegs.indices.reversed() {
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices {
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        
        return results
    }
}

