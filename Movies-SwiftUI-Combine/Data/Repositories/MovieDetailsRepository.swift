//
//  MovieDetailsRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

final class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    private let network: NetworkServiceProtocol
    private let cache: MovieCacheManagerProtocol
    
    init(network: NetworkServiceProtocol, cache: MovieCacheManagerProtocol) {
        self.network = network
        self.cache = cache
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
