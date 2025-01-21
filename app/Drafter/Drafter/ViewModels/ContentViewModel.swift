//
//  ContentViewModel.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Factory
import Foundation
import Observation

@Observable
class ContentViewModel {
    @ObservationIgnored @Injected(\.dataService) private var dataService: any IDataService
    @ObservationIgnored @Injected(\.dbService) private var dbService: any IDatabaseService
    
    var players: [CommonPlayerInfo] = []
    var teams: [Team] = []
    
    init() {
        self.players = self.dbService.getAllPlayers()
        self.teams = self.dbService.getAllTeams()
    }
    
    func filterPlayers(by team: Team.ID) {
        self.players = self.dbService.getPlayersByTeamId(team)
    }
}
