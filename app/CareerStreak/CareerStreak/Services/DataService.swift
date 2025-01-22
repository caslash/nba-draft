//
//  DataService.swift
//  Drafter
//
//  Created by Cameron S Slash on 1/14/25.
//

import Combine
import Foundation
import Observation

public protocol IDataService {
    func fetchPlayerTeams(player_id: Player.ID, completion: @escaping ([Team.ID]) -> Void)
}

@Observable
public class DataService: IDataService {
    private let baseURL: URL = .init(string: "http://127.0.0.1:5000")!
    
    private var cancellables = Set<AnyCancellable>()
    
    private func createRequest<T: Encodable>(path: String, method: String, body: T? = Optional<Data>.none, queryParams: URLQueryItem...) -> URLRequest {
        var components: URLComponents = .init(string: baseURL.appendingPathComponent(path).absoluteString)!
        components.queryItems = queryParams
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method
        if let body { request.httpBody = try? JSONEncoder().encode(body) }
        return request
    }
    
    public func fetchPlayerTeams(player_id: Player.ID, completion: @escaping ([Team.ID]) -> Void) {
        let request = createRequest(path: "/\(player_id)/teams", method: "GET")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PlayerTeamsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { _ in }, receiveValue: {
                completion($0.player_team_history)
            })
            .store(in: &cancellables)
    }
}

extension DataService {
    private struct PlayerTeamsResponse: Decodable {
        var player_id: Player.ID
        var player_team_history: [Team.ID]
    }
}
