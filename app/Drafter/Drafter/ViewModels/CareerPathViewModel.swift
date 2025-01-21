//
//  CareerPathViewModel.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Factory
import Foundation
import Observation

@Observable
public class CareerPathViewModel {
    @ObservationIgnored @Injected(\.dbService) private var dbService: any IDatabaseService
    
    @ObservationIgnored public var possibleAnswers: [CommonPlayerInfo] = []
    public var selected_team_history: [Team.ID] = []
    
    public var gameActive: Bool = false
    
    public var guess: String = ""
    
    init() { }
    
    public func startNewGame() {
        self.gameActive = false
        self.selected_team_history = []
        self.possibleAnswers = self.dbService.getEasyCareerPathAnswers()
        self.selected_team_history = self.possibleAnswers[0].team_history
        self.guess = ""
        self.gameActive = true
    }
    
    public func checkGuess() async {
        let possibleNames = self.possibleAnswers.map { $0.display_first_last }
        let possibleNamesLowercased = possibleNames.map({ $0.lowercased() })
        if possibleNamesLowercased.contains(self.guess.lowercased()) {
            await CareerPathResultPopup(isCorrect: true, otherCorrectAnswers: possibleNames.filter { $0.lowercased() != self.guess.lowercased() }, buttonAction: { self.startNewGame() })
                .present()
        } else {
            await CareerPathResultPopup(isCorrect: false, otherCorrectAnswers: possibleNames, buttonAction: { self.startNewGame() })
                .present()
        }
    }
    
    public func getAllPlayers() -> [String] {
        return self.dbService.getAllPlayers().map({$0.display_first_last})
    }
}
