//
//  Team.swift
//  Drafter
//
//  Created by Cameron Slash on 1/15/25.
//

import Foundation
import GRDB

public struct Team: Codable, Identifiable, FetchableRecord {
    public var id: String
    public var full_name: String
    public var abbreviation: String
    public var nickname: String
    public var city: String
    public var state: String
    public var year_founded: Int
}
