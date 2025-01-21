//
//  DrafterApp.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import MijickPopups
import SwiftUI

@main
struct DrafterApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
