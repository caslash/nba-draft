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
//    @ObservationIgnored @Injected(\.dataService) private var dataService: any IDataService
    @ObservationIgnored @Injected(\.dbService) private var dbService: any IDatabaseService
    
    var player: Player?
    
    init() { }
    
    func fetchRandomPlayer() {
        self.player = dbService.getRandomPlayer()
    }
}
