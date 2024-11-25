//
//  MovieDetailsUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

public protocol MovieDetailsUseCase {
    func execute(with movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError>
}

public final class MovieDetailsUseCaseImpl: MovieDetailsUseCase {
    private let movieDetailsRepository: MovieDetailsRepositoryProtocol
    
    init(movieDetailsRepository: MovieDetailsRepositoryProtocol) {
        self.movieDetailsRepository = movieDetailsRepository
    }
    
    public func execute(with movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError> {
        movieDetailsRepository.fetchMovieDetails(with: movieId)
    }
}

public final class MovieDetailsUseCaseMock: MovieDetailsUseCase {
    public func execute(with movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError> {
        Future<MovieDetailsResponse, NetworkError> { promise in
            promise(.success(MovieDetailsResponse.dummyData))
        }.eraseToAnyPublisher()
    }
}
