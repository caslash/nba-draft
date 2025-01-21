//
//  CareerPathResultPopup.swift
//  Drafter
//
//  Created by Cameron Slash on 1/18/25.
//

import MijickPopups
import SwiftUI

struct CareerPathResultPopup: CenterPopup {
    @State var isCorrect: Bool
    @State var otherCorrectAnswers: [String]
    
    var buttonAction: () -> Void
    var body: some View {
        VStack {
            Text(self.isCorrect ? "Correct!" : "Wrong")
                .font(.title.weight(.black))
                .foregroundStyle(self.isCorrect ? .green : .red)
            Text(self.isCorrect ? "Other correct answers:" : "You could have guessed:")
            Text(self.otherCorrectAnswers.isEmpty ? "No other players" : self.otherCorrectAnswers.joined(separator: ", "))
                .multilineTextAlignment(.center)
                .padding()
            
            Button("New Game") {
                Task {
                    self.buttonAction()
                    await dismissAllPopups()
                }
            }
        }
        .padding(20)
    }
}


#Preview("Correct w/ No Others Popup") {
    CareerPathResultPopup(isCorrect: true, otherCorrectAnswers: []) { }
}
#Preview("Correct w/ Others Popup") {
    CareerPathResultPopup(isCorrect: true, otherCorrectAnswers: ["Jayson Tatum", "LeBron James"]) { }
}
#Preview("Incorrect Popup") {
    CareerPathResultPopup(isCorrect: false, otherCorrectAnswers: []) { }
}
