//
//  ContentView.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Factory
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Career Path") {
                    CareerPathView()
                }
                
                NavigationLink("Multiplayer") {
                    MultiplayerView()
                }
            }
            .navigationTitle("NBA Games")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let _ = Container.shared.dataService.register { DataService() }
    let _ = Container.shared.dbService.register { PreviewDatabaseService() }
    ContentView()
}
