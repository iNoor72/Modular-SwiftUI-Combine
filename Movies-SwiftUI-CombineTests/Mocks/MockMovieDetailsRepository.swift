//
//  MockMovieDetailsRepository.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import Foundation
import NetworkLayer
import CachingLayer
import Combine
@testable import Movies_SwiftUI_Combine

final class MockMovieDetailsRepository: MovieDetailsRepositoryProtocol {
    func getCachedMovieDetails(with id: String) -> CachingLayer.MovieDetailsModel? {
        nil
    }
    
    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<CachingLayer.MovieDetailsModel?, NetworkLayer.NetworkError> {
        return Future<MovieDetailsModel?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
}
