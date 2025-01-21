//
//  CareerPathView.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Factory
import MijickPopups
import SwiftUI
import WrappingStack

struct CareerPathView: View {
    @State private var viewModel: CareerPathViewModel = .init()

    @State private var suggestedPlayers: [String] = []
    @State private var showSuggestions: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if (self.viewModel.gameActive) {
                        CareerPathTeamsView(teams: self.viewModel.selected_team_history)
                    }
                }
                .frame(minHeight: 400)
                .padding()
                
                TextField("Guess A Player", text: self.$viewModel.guess, onEditingChanged: { isEditing in
                    self.showSuggestions = true
                    self.updateSuggestions()
                })
                    .autocorrectionDisabled()
                    .disabled(!self.viewModel.gameActive)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: self.viewModel.guess) {
                        self.updateSuggestions()
                    }
                    .onSubmit {
                        Task {
                            await self.viewModel.checkGuess()
                        }
                    }
                
                if self.showSuggestions && !self.suggestedPlayers.isEmpty {
                    List(suggestedPlayers, id: \.self) { player in
                        Text(player)
                            .onTapGesture {
                                self.viewModel.guess = player
                                self.showSuggestions = false
                            }
                    }
                    .frame(maxHeight: 2000)
                }
                
                Spacer()
            }
            .navigationTitle("Career Path")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        self.viewModel.startNewGame()
                    } label: {
                        Text(self.viewModel.possibleAnswers.isEmpty ? "Start Game" : "New Game")
                    }
                }
            }
        }
    }
    
    private func updateSuggestions() {
        guard self.viewModel.guess.isEmpty else {
            let allPlayers = self.viewModel.getAllPlayers()
            self.suggestedPlayers = allPlayers.filter { $0.lowercased().contains(self.viewModel.guess.lowercased()) }
            return
        }
        
        self.suggestedPlayers = []
    }
}

#Preview {
    let _ = Container.shared.dbService.register { PreviewDatabaseService() }
    CareerPathView()
        .registerPopups(id: .shared) { config in
            config
                .center {
                    $0
                        .cornerRadius(50)
                        .backgroundColor(.gray)
                }
        }
}
