//
//  CareerPathView.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Factory
import MijickPopups
import SwiftUI

struct CareerPathView: View {
    @State private var viewModel: CareerPathViewModel = .init()
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if (self.viewModel.gameActive) {
                        CareerPathTeamsView(teams: self.$viewModel.selected_team_history)
                    }
                }
                .frame(minHeight: 300)
                .padding()
                
                TextField("Guess A Player", text: self.$viewModel.guess, onEditingChanged: { isEditing in
                    self.viewModel.updateSuggestions()
                })
                    .autocorrectionDisabled()
                    .disabled(!self.viewModel.gameActive)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: self.viewModel.guess) {
                        self.viewModel.updateSuggestions()
                    }
                    .onSubmit {
                        Task {
                            await self.viewModel.checkGuess()
                        }
                    }
                
                
                List(self.viewModel.suggestedPlayers, id: \.self) { player in
                    Text(player)
                        .onTapGesture {
                            self.viewModel.guess = player
                        }
                }
                .frame(maxHeight: 2000)
                
                Spacer()
            }
            .navigationTitle("Career Path")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu("New Game") {
                        ForEach(CareerPathDifficulty.allCases) { difficulty in
                            Button {
                                self.viewModel.startNewGame(difficulty: difficulty)
                            } label: {
                                Text(difficulty.displayName)
                            }
                        }
                    }
                    .disabled(self.viewModel.gameActive)
                }
            }
        }
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
