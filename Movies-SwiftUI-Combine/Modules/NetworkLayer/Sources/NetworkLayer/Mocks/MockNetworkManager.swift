//
//  File.swift
//  
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

public class MockNetworkManager: NetworkServiceProtocol {
    nonisolated(unsafe) public static let shared = MockNetworkManager()
    private init() {}
    
    public func fetch<T: Decodable, U: Endpoint>(endpoint: U, expectedType: T.Type) throws -> AnyPublisher<T, NetworkError> {
        let json = """
        {
            "id": 1,
            "name": "Noor",
            "body": "Test"
        }
        """
        let data = Data(json.utf8)
        let response = try? JSONDecoder().decode(T.self, from: data)
        if let response {
            return Future.init { promise in
                promise(.success(response))
            }.eraseToAnyPublisher()
        } else {
            return Future.init { promise in
                promise(.failure(NetworkError.invalidResponse))
            }.eraseToAnyPublisher()
        }
    }
}
