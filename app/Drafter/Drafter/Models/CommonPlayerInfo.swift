//
//  CommonPlayerInfo.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/15/25.
//

import Foundation
import GRDB

public struct CommonPlayerInfo: Codable, Identifiable, FetchableRecord, TableRecord {
    public static var databaseTableName: String = "common_player_info"
    
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
    public var last_affiliation: String
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
    public var playercode: String
    public var from_year: Float
    public var to_year: Float
    public var dleague_flag: String
    public var nba_flag: String
    public var games_played_flag: String
    public var draft_year: String
    public var draft_round: String
    public var draft_number: String
    public var greatest_75_flag: String
    public var team_history: [Team.ID]
    public var total_games_played: Int
}

extension CommonPlayerInfo {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.person_id = try container.decodeIfPresent(String.self, forKey: .person_id) ?? ""
        self.first_name = try container.decodeIfPresent(String.self, forKey: .first_name) ?? ""
        self.last_name = try container.decodeIfPresent(String.self, forKey: .last_name) ?? ""
        self.display_first_last = try container.decodeIfPresent(String.self, forKey: .display_first_last) ?? ""
        self.display_last_comma_first = try container.decodeIfPresent(String.self, forKey: .display_last_comma_first) ?? ""
        self.display_fi_last = try container.decodeIfPresent(String.self, forKey: .display_fi_last) ?? ""
        self.player_slug = try container.decodeIfPresent(String.self, forKey: .player_slug) ?? ""
        self.birthdate = try container.decodeIfPresent(Date.self, forKey: .birthdate) ?? Date.now
        self.school = try container.decodeIfPresent(String.self, forKey: .school) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.last_affiliation = try container.decodeIfPresent(String.self, forKey: .last_affiliation) ?? ""
        self.height = try container.decodeIfPresent(String.self, forKey: .height) ?? ""
        self.weight = try container.decodeIfPresent(String.self, forKey: .weight) ?? ""
        self.season_exp = try container.decodeIfPresent(Float.self, forKey: .season_exp) ?? 0.0
        self.jersey = try container.decodeIfPresent(String.self, forKey: .jersey) ?? ""
        self.position = try container.decodeIfPresent(String.self, forKey: .position) ?? ""
        self.rosterstatus = try container.decodeIfPresent(String.self, forKey: .rosterstatus) ?? ""
        self.games_played_current_season_flag = try container.decodeIfPresent(String.self, forKey: .games_played_current_season_flag) ?? ""
        self.team_id = try container.decodeIfPresent(Int.self, forKey: .team_id) ?? 0
        self.team_name = try container.decodeIfPresent(String.self, forKey: .team_name) ?? ""
        self.team_abbreviation = try container.decodeIfPresent(String.self, forKey: .team_abbreviation) ?? ""
        self.team_code = try container.decodeIfPresent(String.self, forKey: .team_code) ?? ""
        self.team_city = try container.decodeIfPresent(String.self, forKey: .team_city) ?? ""
        self.playercode = try container.decodeIfPresent(String.self, forKey: .playercode) ?? ""
        self.from_year = try container.decodeIfPresent(Float.self, forKey: .from_year) ?? 0.0
        self.to_year = try container.decodeIfPresent(Float.self, forKey: .to_year) ?? 0.0
        self.dleague_flag = try container.decodeIfPresent(String.self, forKey: .dleague_flag) ?? ""
        self.nba_flag = try container.decodeIfPresent(String.self, forKey: .nba_flag) ?? ""
        self.games_played_flag = try container.decodeIfPresent(String.self, forKey: .games_played_flag) ?? ""
        self.draft_year = try container.decodeIfPresent(String.self, forKey: .draft_year) ?? ""
        self.draft_round = try container.decodeIfPresent(String.self, forKey: .draft_round) ?? ""
        self.draft_number = try container.decodeIfPresent(String.self, forKey: .draft_number) ?? ""
        self.greatest_75_flag = try container.decodeIfPresent(String.self, forKey: .greatest_75_flag) ?? ""
        self.total_games_played = try container.decodeIfPresent(Int.self, forKey: .total_games_played) ?? 0
        
        let team_ids_string = try container.decodeIfPresent(String.self, forKey: .team_history) ?? ""
        self.team_history = team_ids_string.split(separator: ",").map { String($0) }
    }
}
