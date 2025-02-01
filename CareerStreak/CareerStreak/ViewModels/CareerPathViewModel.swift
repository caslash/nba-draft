//
//  CareerPathViewModel.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Factory
import Foundation
import Observation

public enum CareerPathDifficulty: CaseIterable, Identifiable {
    case easy, medium, hard, master
    
    public var id: String {
        switch self {
        case .easy:
            "easy"
        case .medium:
            "medium"
        case .hard:
            "hard"
        case .master:
            "master"
        }
    }
    
    var displayName: String {
        switch self {
        case .easy:
            "Easy"
        case .medium:
            "Medium"
        case .hard:
            "Hard"
        case .master:
            "Master"
        }
    }
    
    var queryString: String {
        switch self {
        case .easy:
            "SELECT * FROM players p WHERE p.from_year > 2000 AND p.isActive"
        case .medium:
            "SELECT * FROM players p WHERE (p.from_year > 2000 OR (p.to_year > 2000 AND p.to_year < 2010)) AND p.total_games_played > 600"
        case .hard:
            "SELECT * FROM players p WHERE p.from_year > 1980 AND p.from_year < 2005"
        case .master:
            "SELECT * FROM players p WHERE p.from_year > 1960 AND p.from_year < 2000"
        }
    }
}

@Observable
public class CareerPathViewModel {
    @ObservationIgnored @Injected(\.dbService) private var dbService: any IDatabaseService
    
    @ObservationIgnored public var possibleAnswers: [Player] = []

    public var selected_team_history: [Team.ID] = []
    
    public var gameActive: Bool = false
    
    public var guess: String = ""
    
    public var suggestedPlayers: [String] = []
    
    private var difficulty: CareerPathDifficulty?

    private var allPlayers: [String] = []
    
    init() {
        self.allPlayers = getAllPlayers()
    }
    
    public func startNewGame(difficulty: CareerPathDifficulty) {
        self.difficulty = difficulty
        self.possibleAnswers = self.dbService.getCareerPathAnswers(difficulty.queryString)
        self.selected_team_history = self.possibleAnswers[0].team_history
        self.guess = ""
        self.gameActive = true
        self.updateSuggestions()
    }
    
    public func checkGuess() async {
        let possibleNames = self.possibleAnswers.map { $0.display_first_last }
        let possibleNamesLowercased = possibleNames.map({ $0.lowercased() })
        if possibleNamesLowercased.contains(self.guess.lowercased()) {
            await CareerPathResultPopup(isCorrect: true, otherCorrectAnswers: possibleNames.filter { $0.lowercased() != self.guess.lowercased() }, buttonAction: { self.startNewGame(difficulty: self.difficulty!) })
                .present()
        } else {
            await CareerPathResultPopup(isCorrect: false, otherCorrectAnswers: possibleNames, buttonAction: { self.startNewGame(difficulty: self.difficulty!) })
                .present()
        }
    }
    
    public func getAllPlayers() -> [String] {
        return self.dbService.getAllPlayers().map({$0.display_first_last})
    }
    
    public func updateSuggestions() {
        guard self.guess.isEmpty else {
            self.suggestedPlayers = self.allPlayers.filter { $0.lowercased().contains(self.guess.lowercased()) }
            return
        }
        
        self.suggestedPlayers = self.allPlayers
    }
}
