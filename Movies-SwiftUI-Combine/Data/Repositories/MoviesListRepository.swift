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
    
    func fetchMovies(with page: Int, genreIDs: [Int]) -> AnyPublisher<[MovieModel]?, NetworkError> {
        do {
            let endpoint = MoviesEndpoint.trending(page: page, genreIDs: genreIDs)
            return try network.fetch(endpoint: endpoint, expectedType: MoviesResponse.self)
                .map { [weak self] in
                    if let self {
                        let movieModels = $0.results?.map {
                            $0.toMovieModel(context: self.cache.managedObjectContext)
                        }
                        
                        self.cache.save()
                        return movieModels
                    }
                    
                    return nil
                }
                .eraseToAnyPublisher()
        } catch {
            return Future<[MovieModel]?, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
    
    func getCachedMovies() -> [MovieModel] {
        let request = MovieModel.fetchRequest()
        request.sortDescriptors = []
        return cache.fetch(MovieModel.self, with: request) as! [MovieModel]
    }
}
