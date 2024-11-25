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
    func execute() -> AnyPublisher<[GenreItem], NetworkError>
}

public final class GenresUseCaseImpl: GenresUseCase {
    private let genreRepository: GenresRepositoryProtocol
    
    init(genreRepository: GenresRepositoryProtocol) {
        self.genreRepository = genreRepository
    }
    
    public func execute() -> AnyPublisher<[GenreItem], NetworkError> {
        genreRepository.fetchGenres()
    }
}

public final class GenresUseCaseMock: GenresUseCase {
    public func execute() -> AnyPublisher<[GenreItem], NetworkError> {
        Future<[GenreItem], NetworkError> { promise in
            promise(.success([GenreItem(id: 1, name: "Test")]))
        }.eraseToAnyPublisher()
    }
}
