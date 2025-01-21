//
//  CareerPathTeamsView.swift
//  Drafter
//
//  Created by Cameron Slash on 1/20/25.
//

import SwiftUI
import WrappingStack

public struct CareerPathTeamsView: View {
    @State public var teams: [Team.ID]
    
    public var body: some View {
        WrappingHStack(id: \.offset) {
            ForEach(Array(self.teams.enumerated()), id: \.offset) { index, teamId in
                Image(teamId)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 65)
                
                if index < self.teams.count - 1 {
                    Image(systemName: "arrow.forward")
                        .font(.title3.weight(.black))
                        .frame(minWidth: 30)
                }
            }
        }
        .frame(minHeight: 400)
    }
}

#Preview {
    CareerPathTeamsView(teams: ["1610612744", "1610612754", "1610612749", "1610612741", "1610612739", "1610612737"])
}
