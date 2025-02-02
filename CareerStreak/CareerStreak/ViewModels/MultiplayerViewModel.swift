//
//  MultiplayerViewModel.swift
//  CareerStreak
//
//  Created by Cameron Slash on 2/1/25.
//

import Foundation
import SocketIO
import Observation

@Observable
public class MultiplayerViewModel {
    public var manager: SocketManager
    public var socket: SocketIOClient { self.manager.defaultSocket }
    
    init () {
        self.manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        
        self.socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected")
        }
    }
    
    public func connect() {
        self.socket.connect()
    }
}
