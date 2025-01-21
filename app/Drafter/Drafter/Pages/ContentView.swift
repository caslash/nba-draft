//
//  ContentView.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Factory
import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel = .init()
    var body: some View {
        NavigationView {
            List(self.viewModel.players) { player in
                VStack(alignment: .leading) {
                    Text(player.display_first_last)
                    
                    Spacer()
                    
                    HStack {
                        ForEach(player.team_history, id: \.self) { team_id in
                            Image(team_id)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .navigationTitle("Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Filter") {
                        ForEach(self.viewModel.teams.sorted(by: \.nickname)) { team in
                            Button {
                                self.viewModel.filterPlayers(by: team.id)
                            } label: {
                                Label(team.nickname, image: team.id)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Text("Showing: \(self.viewModel.players.count) players")
                }
            }
        }
    }
}

#Preview {
    let _ = Container.shared.dataService.register { DataService() }
    let _ = Container.shared.dbService.register { PreviewDatabaseService() }
    ContentView()
}
