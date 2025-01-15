//
//  CommonPlayerInfo.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/15/25.
//

import Foundation
import GRDB

public struct CommonPlayerInfo: Codable, Identifiable, FetchableRecord {
    public var id: String { person_id }
    public var person_id: String
    public var first_name: String
    public var last_name: String
    public var display_first_last: String
    public var display_last_comma_first: String
    public var display_fi_last: String
    public var player_slug: String
    public var birthdate: Date
    public var school: String
    public var country: String
    public var last_affiliation: String?
    public var height: String
    public var weight: String?
    public var season_exp: Float
    public var jersey: String?
    public var position: String
    public var rosterstatus: String
    public var games_played_current_season_flag: String
    public var team_id: Int
    public var team_name: String
    public var team_abbreviation: String
    public var team_code: String
    public var team_city: String
    public var playercode: String?
    public var from_year: Float?
    public var to_year: Float?
    public var dleague_flag: String
    public var nba_flag: String
    public var games_played_flag: String
    public var draft_year: String?
    public var draft_round: String?
    public var draft_number: String?
    public var greatest_75_flag: String
}
