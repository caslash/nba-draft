//
//  Player.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/15/25.
//

import Foundation
import GRDB

public struct Player: Codable, Identifiable, FetchableRecord {
    public var id: String
    public var full_name: String
    public var first_name: String
    public var last_name: String
    public var is_active: Bool
}
