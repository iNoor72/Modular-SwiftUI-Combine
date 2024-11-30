//
//  MockSearchRepository.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import Foundation
import NetworkLayer
import CachingLayer
import Combine
@testable import Movies_SwiftUI_Combine

final class MockSearchRepository: SearchRepositoryProtocol {
    func searchMovies(page: Int, query: String) -> AnyPublisher<CachingLayer.MoviesResponseModel?, NetworkLayer.NetworkError> {
        return Future<MoviesResponseModel?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
}
