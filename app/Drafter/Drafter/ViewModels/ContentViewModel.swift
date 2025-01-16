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
    
    var player: Player?
    var teams: [Team] = []
    
    init() { }
    
    func fetchRandomPlayer() {
        self.player = self.dbService.getRandomPlayer()
        self.dataService.fetchPlayerTeams(player_id: player!.id) { teamIds in
            self.teams = self.dbService.getPlayerTeamsFromID(teamIds)
        }
    }
}
