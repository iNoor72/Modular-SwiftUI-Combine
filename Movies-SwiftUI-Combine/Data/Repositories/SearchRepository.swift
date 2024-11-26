//
//  SearchRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import Combine
import NetworkLayer

final class SearchRepository: SearchRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func searchMovies(page: Int, query: String) -> AnyPublisher<MoviesResponse, NetworkError> {
        do {
            let endpoint = SearchEndpoint.search(page: page, query: query)
            return try network.fetch(endpoint: endpoint, expectedType: MoviesResponse.self)
                .eraseToAnyPublisher()
        } catch {
            return Future<MoviesResponse, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
}
