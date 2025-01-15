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
    var message: String? { get set }
    
    func fetchResponse()
    func fetchNameResponse(name: String)
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
    
    public var message: String?
    
    public func fetchResponse() {
        let request = createRequest(path: "", method: "GET")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print("completion: \($0)") }, receiveValue: { self.message = $0.message })
            .store(in: &cancellables)
    }
    
    public func fetchNameResponse(name: String) {
        let request = createRequest(path: "/hello", method: "GET", queryParams: URLQueryItem(name: "name", value: name))
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { print("completion: \($0)") }, receiveValue: { self.message = $0.message })
            .store(in: &cancellables)
    }
}
