//
//  GenresUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

public protocol GenresUseCase {
    func execute() -> AnyPublisher<GenresResponse, NetworkError>
}

public final class GenresUseCaseImpl: GenresUseCase {
    private let genreRepository: GenresRepositoryProtocol
    
    init(genreRepository: GenresRepositoryProtocol) {
        self.genreRepository = genreRepository
    }
    
    public func execute() -> AnyPublisher<GenresResponse, NetworkError> {
        genreRepository.fetchGenres()
    }
}

public final class GenresUseCaseMock: GenresUseCase {
    public func execute() -> AnyPublisher<GenresResponse, NetworkError> {
        Future<GenresResponse, NetworkError> { promise in
            promise(.success(GenresResponse(genres: [])))
        }.eraseToAnyPublisher()
    }
}
