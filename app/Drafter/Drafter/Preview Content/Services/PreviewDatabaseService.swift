//
//  PreviewDatabaseService.swift
//  Drafter
//
//  Created by Cameron Slash on 1/17/25.
//

import Foundation
import GRDB
import Observation

@Observable
public class PreviewDatabaseService: IDatabaseService {
    public var dbQueue: GRDB.DatabaseQueue!
    
    required public init() {
        guard let bundlePath = Bundle.main.path(forResource: "nba", ofType: "sqlite") else {
            fatalError("Databae could not be found in bundle")
        }
        
        do {
            self.dbQueue = try DatabaseQueue(path: bundlePath)
            print("Database ready at: \(bundlePath)")
        } catch {
            fatalError("Database setup failed: \(error.localizedDescription)")
        }
    }
    public func getAllTeams() -> [Team] {
        do {
            return try dbQueue.read { db in
                try Team.fetchAll(db, sql: "SELECT * FROM team")
            }
        } catch {
            fatalError("Error fetching teams: \(error.localizedDescription)")
        }
    }
    
    public func getAllPlayers() -> [CommonPlayerInfo] {
        do {
            return try dbQueue.read { db in
                try CommonPlayerInfo.fetchAll(db, sql: "SELECT * FROM common_player_info")
            }
        } catch {
            fatalError("Error fetching players: \(error.localizedDescription)")
        }
    }
    
    public func getRandomPlayer() -> CommonPlayerInfo {
        do {
            var player: CommonPlayerInfo? = nil
            try dbQueue.read { db in
                player = try CommonPlayerInfo.fetchOne(
                    db,
                    sql: "SELECT * FROM common_player_info cpi WHERE cpi.to_year > 1960 ORDER BY RANDOM() "
                )
            }
            guard let player else { fatalError("Couldn't choose a random player") }
            
            return player
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getCareerPathAnswers() -> [CommonPlayerInfo] {
        do {
            var player: CommonPlayerInfo? = nil
            try dbQueue.read { db in
                player = try CommonPlayerInfo.fetchOne(
                    db,
                    sql: "SELECT * FROM common_player_info cpi WHERE cpi.from_year > 2000 AND cpi.team_history LIKE '%,%' ORDER BY RANDOM()"
                )
            }
            guard let player else { fatalError("Couldn't choose a random player") }
            
            let formattedTeamHistory: String = player.team_history.joined(separator: ",")
            
            var possibleAnswers: [CommonPlayerInfo] = []
            try dbQueue.read { db in
                possibleAnswers = try CommonPlayerInfo.fetchAll(
                    db,
                    sql: "SELECT * FROM common_player_info cpi WHERE cpi.from_year > 2000 AND cpi.team_history LIKE '\(formattedTeamHistory)'"
                )
            }
            
            return possibleAnswers
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getEasyCareerPathAnswers() -> [CommonPlayerInfo] {
        do {
            var players: [CommonPlayerInfo] = []
            try dbQueue.read { db in
                players = try CommonPlayerInfo.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM common_player_info cpi
                        WHERE cpi.from_year > 2000
                        ORDER BY cpi.total_games_played DESC
                        LIMIT 100
                        """
                )
            }
            guard let player = players.randomElement() else { fatalError("Couldn't choose a random player") }
            
            let formattedTeamHistory: String = player.team_history.joined(separator: ",")
            
            var possibleAnswers: [CommonPlayerInfo] = []
            try dbQueue.read { db in
                possibleAnswers = try CommonPlayerInfo.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM common_player_info cpi
                        WHERE cpi.from_year > 2000
                        AND cpi.team_history LIKE '\(formattedTeamHistory)'
                        ORDER BY cpi.total_games_played DESC
                        LIMIT 100
                        """
                )
            }
            
            return possibleAnswers
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getPlayerTeamsFromId(_ teams: [Team.ID]) -> [Team] {
        let formattedTeams = teams.map { return "('\($0)')" }.joined(separator: ",")
        
        do {
            var teams: [Team] = []
            try dbQueue.read { db in
                teams = try Team.fetchAll(
                    db,
                    sql: """
                        WITH id_array(id) AS (
                            VALUES
                            \(formattedTeams)
                        )
                        SELECT * FROM id_array
                        JOIN team ON id_array.id = team.id
                        """
                )
            }
            
            return teams
        } catch {
            fatalError("Error fetching teams: \(error.localizedDescription)")
        }
    }
    
    public func getPlayersByTeamId(_ teamId: Team.ID) -> [CommonPlayerInfo] {
        do {
            var players: [CommonPlayerInfo] = []
            try dbQueue.read { db in
                players = try CommonPlayerInfo.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM common_player_info cpi
                        WHERE cpi.team_history LIKE '%\(teamId)%'
                        """
                )
            }
            
            return players
        } catch {
            fatalError("Error fetching Celtics players: \(error.localizedDescription)")
        }
    }
}
