//
//  MovieDetailsUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public protocol MovieDetailsUseCase {
//    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetails, NetworkManager>
}

public final class MovieDetailsUseCaseImpl: MovieDetailsUseCase {
    private let movieDetailsRepository: MovieDetailsRepositoryProtocol
    
    init(movieDetailsRepository: MovieDetailsRepositoryProtocol) {
        self.movieDetailsRepository = movieDetailsRepository
    }
//    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetails, Error> {
//        
//    }
}

public final class MovieDetailsUseCaseMock: MovieDetailsUseCase {
//    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetails, Error> {
//        return Just(MovieDetailsMockModel())
//    }
}
