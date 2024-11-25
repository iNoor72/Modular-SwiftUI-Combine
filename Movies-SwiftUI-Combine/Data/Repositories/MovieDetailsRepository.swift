//
//  MovieDetailsRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

final class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError> {
        do {
            let endpoint = MovieDetailsEndpoint.movieDetails(id: movieId)
            return try network.fetch(endpoint: endpoint, expectedType: MovieDetailsResponse.self)
                .eraseToAnyPublisher()
        } catch {
            return Future<MovieDetailsResponse, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
}
