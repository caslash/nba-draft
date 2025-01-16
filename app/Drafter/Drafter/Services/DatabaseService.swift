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
    
    func getRandomPlayer() -> Player
    func getPlayerTeamsFromID(_ teams: [Team.ID]) -> [Team]
}

@Observable
public class DatabaseService: IDatabaseService {
    public var dbQueue: DatabaseQueue!
    
    private var dbPath: String {
        let documentsDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationPath = documentsDirectory.appendingPathComponent(self.dbName)
        return destinationPath.path()
    }
    private let dbName: String = "nba.sqlite"
    private let fileManager = FileManager.default
    
    required public init() {
        self.copyDB()
        self.setupDB()
    }

    // MARK: Database Setup
    private func copyDB() {
        guard let bundlePath = Bundle.main.path(forResource: "nba", ofType: "sqlite") else {
            fatalError("Database could not be found in bundle")
        }
        
        if !fileManager.fileExists(atPath: self.dbPath) {
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: self.dbPath)
                print("Database copied to: \(self.dbPath)")
            } catch {
                fatalError("Error copyt database: \(error.localizedDescription)")
            }
        } else {
            print("Database exists at: \(self.dbPath)")
        }
    }
    
    private func setupDB() {
        do {
            dbQueue = try DatabaseQueue(path: self.dbPath)
            print("Database ready at: \(self.dbPath)")
        } catch {
            fatalError("Database setup failed: \(error.localizedDescription)")
        }
    }
    
    public func getRandomPlayer() -> Player {
        do {
            var player: Player? = nil
            try dbQueue.read { db in
                player = try Player.fetchOne(
                    db,
                    sql: "SELECT * FROM player ORDER BY RANDOM()"
                )
            }
            guard let player else { fatalError("Couldn't choose a random player") }
            
            return player
        } catch {
            fatalError("Error fetching random player: \(error.localizedDescription)")
        }
    }
    
    public func getPlayerTeamsFromID(_ teams: [Team.ID]) -> [Team] {
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
}
