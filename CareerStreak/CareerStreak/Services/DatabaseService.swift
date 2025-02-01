//
//  DatabaseService.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Foundation
import GRDB
import Observation

public protocol IDatabaseService {
    var dbQueue: DatabaseQueue! { get }
    
    init()
    
    func getAllTeams() -> [Team]
    func getAllPlayers() -> [Player]
    func getRandomPlayer() -> Player
    func getCareerPathAnswers(_ query: String) -> [Player]
    func getEasyCareerPathAnswers() -> [Player]
    func getPlayerTeamsFromId(_ teams: [Team.ID]) -> [Team]
    func getPlayersByTeamId(_ teamId: Team.ID) -> [Player]
}

@Observable
public class DatabaseService: IDatabaseService {
    public var dbQueue: DatabaseQueue!
    
    private var dbPath: String {
        let documentsDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationPath = documentsDirectory.appendingPathComponent(self.dbName)
        return destinationPath.path()
    }
    private let dbName: String = "nba.db"
    private let fileManager = FileManager.default
    
    required public init() {
        self.copyDB()
        self.setupDB()
    }

    // MARK: Database Setup
    private func copyDB() {
        guard let bundlePath = Bundle.main.path(forResource: "nba", ofType: "db") else {
            fatalError("Database could not be found in bundle")
        }
        
        if !self.fileManager.fileExists(atPath: self.dbPath) {
            do {
                print(bundlePath)
                try self.fileManager.copyItem(atPath: bundlePath, toPath: self.dbPath)
                print("Database copied to: \(self.dbPath)")
            } catch {
                fatalError("Error copying database: \(error.localizedDescription)")
            }
        } else {
            print("Database exists at: \(self.dbPath)")
        }
    }
    
    private func setupDB() {
        do {
            self.dbQueue = try DatabaseQueue(path: self.dbPath)
            print("Database ready at: \(self.dbPath)")
        } catch {
            fatalError("Database setup failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: Database Search Functions
    public func getAllTeams() -> [Team] {
        do {
            return try dbQueue.read { db in
                try Team.fetchAll(db, sql: "SELECT * FROM team")
            }
        } catch {
            fatalError("Error fetching teams: \(error.localizedDescription)")
        }
    }
    
    public func getAllPlayers() -> [Player] {
        do {
            return try dbQueue.read { db in
                try Player.fetchAll(db, sql: "SELECT * FROM players")
            }
        } catch {
            fatalError("Error fetching players: \(error.localizedDescription)")
        }
    }
    
    public func getRandomPlayer() -> Player {
        do {
            var player: Player? = nil
            try dbQueue.read { db in
                player = try Player.fetchOne(
                    db,
                    sql: "SELECT * FROM players p WHERE p.to_year > 1960 ORDER BY RANDOM() "
                )
            }
            guard let player else { fatalError("Couldn't choose a random player") }
            
            return player
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getCareerPathAnswers(_ query: String) -> [Player] {
        do {
            var player: Player? = nil
            try dbQueue.read { db in
                player = try Player.fetchOne(
                    db,
                    sql: "\(query) AND p.team_history LIKE '%,%' ORDER BY RANDOM()"
                )
            }
            guard let player else { fatalError("Couldn't choose a random player") }
            
            let formattedTeamHistory: String = player.team_history.joined(separator: ",")
            
            var possibleAnswers: [Player] = []
            try dbQueue.read { db in
                possibleAnswers = try Player.fetchAll(
                    db,
                    sql: "\(query) AND p.team_history LIKE '\(formattedTeamHistory)'"
                )
            }
            
            return possibleAnswers
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getEasyCareerPathAnswers() -> [Player] {
        do {
            var players: [Player] = []
            try dbQueue.read { db in
                players = try Player.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM players p
                        WHERE p.from_year > 2000
                        AND p.team_history LIKE '%,%'
                        ORDER BY p.total_games_played DESC
                        LIMIT 100
                        """
                )
            }
            guard let player = players.randomElement() else { fatalError("Couldn't choose a random player") }
            
            let formattedTeamHistory: String = player.team_history.joined(separator: ",")
            
            var possibleAnswers: [Player] = []
            try dbQueue.read { db in
                possibleAnswers = try Player.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM players p
                        WHERE p.from_year > 2000
                        AND p.team_history LIKE '\(formattedTeamHistory)'
                        ORDER BY p.total_games_played DESC
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
    
    public func getPlayersByTeamId(_ teamId: Team.ID) -> [Player] {
        do {
            var players: [Player] = []
            try dbQueue.read { db in
                players = try Player.fetchAll(
                    db,
                    sql: """
                        SELECT * FROM players p
                        WHERE p.team_history LIKE '%\(teamId)%'
                        """
                )
            }
            
            return players
        } catch {
            fatalError("Error fetching Celtics players: \(error.localizedDescription)")
        }
    }
}
