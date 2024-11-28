//
//  MoviesListRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

final class MoviesListRepository: MoviesListRepositoryProtocol {
    private let network: NetworkServiceProtocol
    private let cache: MovieCacheManagerProtocol
    
    init(network: NetworkServiceProtocol, cache: MovieCacheManagerProtocol) {
        self.network = network
        self.cache = cache
    }
    
    func fetchMovies(with page: Int, genreIDs: [Int]) -> AnyPublisher<MoviesResponseModel?, NetworkError> {
        do {
            let endpoint = MoviesEndpoint.trending(page: page, genreIDs: genreIDs)
            return try network.fetch(endpoint: endpoint, expectedType: MoviesResponse.self)
                .map { [weak self] in
                    guard let self else { return nil }
                    
                    let response = $0.toMoviesResponseModel(context: self.cache.managedObjectContext)
                    
                    self.cache.save()
                    return response
                }
                .eraseToAnyPublisher()
        } catch {
            return Future<MoviesResponseModel?, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
    
    func getCachedMovies() -> [MovieModel] {
        let request = MovieModel.fetchRequest()
        return cache.fetch(MovieModel.self, with: request) 
    }
}
