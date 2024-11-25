//
//  MoviesListRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer
import Combine

final class MoviesListRepository: MoviesListRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func fetchMovies(with page: Int, genreIDs: [Int]) -> AnyPublisher<MoviesResponse, NetworkError> {
        do {
            let endpoint = MoviesEndpoint.trending(page: page, genreIDs: genreIDs)
            return try network.fetch(endpoint: endpoint, expectedType: MoviesResponse.self)
                .eraseToAnyPublisher()
        } catch {
            return Future<MoviesResponse, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
}
