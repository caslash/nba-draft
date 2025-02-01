//
//  Player.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/15/25.
//

import Foundation
import GRDB

public struct Player: Codable, Identifiable, FetchableRecord, TableRecord {
    public static var databaseTableName: String = "players"
    
    public var id: Int
    public var first_name: String
    public var last_name: String
    public var display_first_last: String
    public var display_fi_last: String
    public var birthdate: Date
    public var school: String
    public var country: String
    public var height: String
    public var weight: String
    public var season_exp: Int
    public var jersey: Int?
    public var position: String
    public var isActive: Bool
    public var from_year: Int
    public var to_year: Int
    public var draft_year: String
    public var draft_round: String
    public var draft_number: String
    public var team_history: [Team.ID]
    public var total_games_played: Int
}

extension Player {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.first_name = try container.decodeIfPresent(String.self, forKey: .first_name) ?? ""
        self.last_name = try container.decodeIfPresent(String.self, forKey: .last_name) ?? ""
        self.display_first_last = try container.decodeIfPresent(String.self, forKey: .display_first_last) ?? ""
        self.display_fi_last = try container.decodeIfPresent(String.self, forKey: .display_fi_last) ?? ""
        self.birthdate = try container.decodeIfPresent(Date.self, forKey: .birthdate) ?? Date.now
        self.school = try container.decodeIfPresent(String.self, forKey: .school) ?? ""
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.height = try container.decodeIfPresent(String.self, forKey: .height) ?? ""
        self.weight = try container.decodeIfPresent(String.self, forKey: .weight) ?? ""
        self.season_exp = try container.decodeIfPresent(Int.self, forKey: .season_exp) ?? 0
        self.jersey = try container.decodeIfPresent(Int.self, forKey: .jersey)
        self.position = try container.decodeIfPresent(String.self, forKey: .position) ?? ""
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        self.from_year = try container.decodeIfPresent(Int.self, forKey: .from_year) ?? 0
        self.to_year = try container.decodeIfPresent(Int.self, forKey: .to_year) ?? 0
        self.draft_year = try container.decodeIfPresent(String.self, forKey: .draft_year) ?? ""
        self.draft_round = try container.decodeIfPresent(String.self, forKey: .draft_round) ?? ""
        self.draft_number = try container.decodeIfPresent(String.self, forKey: .draft_number) ?? ""
        self.total_games_played = try container.decodeIfPresent(Int.self, forKey: .total_games_played) ?? 0
        
        let team_ids_string = try container.decodeIfPresent(String.self, forKey: .team_history) ?? ""
        self.team_history = team_ids_string.split(separator: ",").map { String($0) }
    }
}
