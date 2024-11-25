//
//  NetworkManager.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

public final class NetworkManager: NetworkServiceProtocol {
    @MainActor public static let shared = NetworkManager()
    private init() {}
    
    public func fetch<T: Decodable, U: Endpoint>(
        endpoint: U,
        expectedType: T.Type
    ) throws -> AnyPublisher<T, NetworkError> {
        guard let request = try? endpoint.asURLRequest() else {
            return Fail(error: NetworkError.urlConstructionError).eraseToAnyPublisher()
        }
        
        //token checking
        
        //do the request
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard (200 ... 299).contains(httpResponse.statusCode) else {
                    throw NetworkError.failedRequest
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                guard let error = error as? NetworkError else {
                    return NetworkError.decodingError
                }
                
                return error
            }
            .eraseToAnyPublisher()
    }
}
