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
                    
                    //We need to cache movies only
                    let movies = response.movies?.allObjects as? [MovieModel]
                    movies?.forEach { movie in
                        self.cache.addObject(movie.movieID ?? "", movie, MovieModel.self)
                    }
                    
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
        do {
            let request = MovieModel.fetchRequest()
            return try cache.fetch(MovieModel.self, with: request)
        } catch {
            NSLog("Error fetching cached movies: \(error)")
            return []
        }
    }
}
