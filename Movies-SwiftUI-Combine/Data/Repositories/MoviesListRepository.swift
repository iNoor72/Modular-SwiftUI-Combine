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
    let service = MovieModelService()
    
    init(network: NetworkServiceProtocol, cache: MovieCacheManagerProtocol) {
        self.network = network
        self.cache = cache
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
    
    func cacheMovies(_ movies: [MoviesResponseItem]) {
//        movies.forEach { movie in
//            let entity = MovieModel(context: cache.managedObjectContext)
//            entity.id = Int16(movie.id ?? 0)
//            entity.title = movie.title ?? ""
//            entity.releaseDate = movie.releaseDate ?? ""
//            entity.posterPath = movie.posterPath ?? ""
//            service.add(movie: entity)
//        }
//        
//        service.applyChanges()
    }
}
