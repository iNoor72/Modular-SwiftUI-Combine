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
    
    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetailsModel?, NetworkError> {
        do {
            let endpoint = MovieDetailsEndpoint.movieDetails(id: movieId)
            return try network.fetch(endpoint: endpoint, expectedType: MovieDetailsResponse.self)
                .compactMap { [weak self] in
                    guard let self else { return nil }
                    
                    let response = $0.toMovieDetailsModel(context: cache.managedObjectContext)
                     
                    self.cache.addObject(response.movieID ?? "", response, MovieDetailsModel.self)
                    return response
                }
                .eraseToAnyPublisher()
        } catch {
            return Future<MovieDetailsModel?, NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
    
    func getCachedMovieDetails(with id: String) -> MovieDetailsModel? {
        do {
            let request = MovieDetailsModel.fetchRequest()
            return try cache.fetch(MovieDetailsModel.self, with: request).first { $0.movieID == id }
        } catch {
            NSLog("Error fetching cached movies: \(error)")
            return nil
        }
    }
}
