//
//  MultiplayerView.swift
//  CareerStreak
//
//  Created by Cameron Slash on 2/1/25.
//

import SwiftUI

struct MultiplayerView: View {
    @State private var viewModel: MultiplayerViewModel = .init()
    
    var body: some View {
        Button("Connect To Socket") {
            self.viewModel.connect()
        }
    }
}

#Preview {
    MultiplayerView()
}
