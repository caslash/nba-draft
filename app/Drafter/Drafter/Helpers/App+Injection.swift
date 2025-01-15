//
//  App+Injection.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Factory
import Foundation

extension Container {
    var dataService: Factory<any IDataService> {
        Factory(self) { DataService() }
            .singleton
    }
    
    var dbService: Factory<any IDatabaseService> {
        Factory(self) { DatabaseService() }
            .singleton
    }
}
