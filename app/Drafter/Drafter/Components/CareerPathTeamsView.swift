//
//  CareerPathTeamsView.swift
//  Drafter
//
//  Created by Cameron Slash on 1/20/25.
//

import SwiftUI

public struct CareerPathTeamsView: View {
    @Binding public var teams: [Team.ID]
    
    public var body: some View {
        WrappingCollectionView(self.teams) { teamId in
            Image(teamId)
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
        } inBetweenContent: {
            Image(systemName: "arrow.forward")
                .font(.title3.weight(.black))
        }
    }
}

#Preview {
    CareerPathTeamsView(teams: .constant(["1610612744", "1610612754", "1610612749", "1610612741", "1610612739", "1610612737","1610612744"]))
}
