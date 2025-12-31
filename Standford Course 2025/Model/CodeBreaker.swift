//
//  CodeBreaker.swift
//  Standford Course 2025
//
//  Created by visortix on 07.12.2025.
//

import SwiftUI

enum Peg: Equatable, Hashable {
    case color(Color)
    case emoji(String)
    case missing
}

@Observable
class CodeBreaker {
    var name: String
    
    // MARK: Codes
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    
    // MARK: Pegs
    let pegChoices: [Peg]
    
    // MARK: Time
    var startTime = Date.now
    var endTime: Date? = nil
    
    // MARK: Info
    var pegCount: Int { masterCode.pegs.count }
    var isOver: Bool { attempts.first?.pegs == masterCode.pegs }
    
    private static let pegColors: [Peg] = [
        .color(.red),
        .color(.green),
        .color(.yellow),
        .color(.blue),
        .color(.purple),
        .color(.cyan)
    ]

    private static let pegEmojis: [Peg] = [
        .emoji("😎"),
        .emoji("🤗"),
        .emoji("👽"),
        .emoji("😈"),
        .emoji("🥶"),
        .emoji("😡")
    ]
    
    // MARK: - Inits
    
    init(name: String = "Code Breaker", pegChoices: [Peg], count: Int) {
        self.name = name
        self.pegChoices = pegChoices
        var masterCode = Code(kind: .master(isHidden: true), count: count)
        masterCode.randomize(from: self.pegChoices)
        self.masterCode = masterCode
        guess = Code(kind: .guess, count: count)
    }
    
    convenience init(game: GameType, count: Int) {
        let name: String
        let pegChoices: [Peg]
        
        switch game {
        case .colors:
            name = "Cool Colors"
            pegChoices = CodeBreaker.pegColors
        case .emojis:
            name = "Freaky Faces"
            pegChoices = CodeBreaker.pegEmojis
        }
        
        self.init(name: name, pegChoices: pegChoices, count: count)
    }
    
    convenience init(name: String = "Code Breaker", pegChoices: [Peg]) {
        self.init(name: name, pegChoices: pegChoices, count: Int.randomPegCount())
    }
    
    convenience init(game: GameType) {
        self.init(game: game, count: Int.randomPegCount())
    }
    
    convenience init() {
        self.init(game: GameType.random())
    }
    
    // MARK: - Logic
    
    func attemptGuess() {
        let missingPegs = guess.pegs.filter({ $0 == Peg.missing })
        guard missingPegs.count != masterCode.pegs.count else { return }
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else {
            return
        }
        
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard masterCode.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func restart() {
        let newGame = CodeBreaker(name: name, pegChoices: pegChoices)
        
        self.name = newGame.name
        self.masterCode = newGame.masterCode
        self.guess = newGame.guess
        self.attempts = newGame.attempts
        self.startTime = newGame.startTime
        self.endTime = newGame.endTime
    }
    
    func changeGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPeg = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPeg + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        } else {
            guess.pegs[index] = pegChoices.first ?? Peg.missing
        }
    }
    
    enum GameType {
        case colors
        case emojis
        static func random() -> GameType {
            let randomNumber = Int.random(in: 1...2)
            switch randomNumber {
            case 1:  return .colors
            case 2:  return .emojis
            default: return .emojis
            }
        }
    }
}

extension CodeBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
