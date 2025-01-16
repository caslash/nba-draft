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
        VStack {
            Text("Player:")
            
            Text(self.viewModel.player != nil ? "\(self.viewModel.player!.full_name)" : "No Player Found")
            
            Text("Teams:")
            
            Text(self.viewModel.teams.map{ return $0.full_name }.joined(separator: " -> "))
                .multilineTextAlignment(.center)
            
            Button {
                self.viewModel.fetchRandomPlayer()
            } label: {
                Text("Get Player")
            }
        }
    }
}

#Preview {
    let _ = Container.shared.dataService.register { DataService() }
    ContentView()
}
