//
//  SearchMoviesUseCase.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import Combine
import NetworkLayer

protocol SearchMoviesUseCase {
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponse, NetworkError>
}

final class SearchMoviesUseCaseImpl: SearchMoviesUseCase {
    private let repository: SearchRepositoryProtocol
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponse, NetworkError> {
        repository.searchMovies(page: page, query: query)
    }
}

final class SearchMoviesUseCaseMock: SearchMoviesUseCase {
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponse, NetworkError> {
        Future<MoviesResponse, NetworkError> { promise in
            promise(.success(MoviesResponse.dummyData))
        }.eraseToAnyPublisher()
    }
}
