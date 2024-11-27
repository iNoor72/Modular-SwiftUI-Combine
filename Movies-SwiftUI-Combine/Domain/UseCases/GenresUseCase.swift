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
    func execute() -> AnyPublisher<[GenreViewItem], NetworkError>
}

public final class GenresUseCaseImpl: GenresUseCase {
    private let genreRepository: GenresRepositoryProtocol
    
    init(genreRepository: GenresRepositoryProtocol) {
        self.genreRepository = genreRepository
    }
    
    public func execute() -> AnyPublisher<[GenreViewItem], NetworkError> {
        genreRepository.fetchGenres()
    }
}

public final class GenresUseCaseMock: GenresUseCase {
    public func execute() -> AnyPublisher<[GenreViewItem], NetworkError> {
        Future<[GenreViewItem], NetworkError> { promise in
            promise(.success([]))
        }.eraseToAnyPublisher()
    }
}
