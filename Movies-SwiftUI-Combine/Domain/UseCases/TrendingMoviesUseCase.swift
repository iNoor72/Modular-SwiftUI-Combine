//
//  TrendingMoviesUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public protocol TrendingMoviesUseCase {
//    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error>
}

public final class TrendingMoviesUseCaseImpl: TrendingMoviesUseCase {
    private let moviesListRepository: MoviesListRepositoryProtocol
    
    init(moviesListRepository: MoviesListRepositoryProtocol) {
        self.moviesListRepository = moviesListRepository
    }
    
//    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error> {
//        
//    }
}

public final class TrendingMoviesUseCaseMock: TrendingMoviesUseCase {
//    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error> {
//        
//    }
}
