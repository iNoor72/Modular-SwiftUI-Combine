//
//  TrendingMoviesUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

public protocol TrendingMoviesUseCase {
    func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<MoviesResponse, NetworkError>
    func cache(_ movies: [MoviesResponseItem])
}

public final class TrendingMoviesUseCaseImpl: TrendingMoviesUseCase {
    private let moviesListRepository: MoviesListRepositoryProtocol
    init(moviesListRepository: MoviesListRepositoryProtocol) {
        self.moviesListRepository = moviesListRepository
    }
    
    public func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<MoviesResponse, NetworkError> {
        moviesListRepository.fetchMovies(with: page, genreIDs: genres.compactMap { $0.id })
    }
    
    public func cache(_ movies: [MoviesResponseItem]) {
        moviesListRepository.cacheMovies(movies)
    }
}

public final class TrendingMoviesUseCaseMock: TrendingMoviesUseCase {
    public func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<MoviesResponse, NetworkError> {
        Future<MoviesResponse, NetworkError> { promise in
            promise(.success(MoviesResponse.dummyData))
        }.eraseToAnyPublisher()
    }
    
    public func cache(_ movies: [MoviesResponseItem]) { }
}
