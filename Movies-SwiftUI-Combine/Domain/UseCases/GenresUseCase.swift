//
//  GenresUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public protocol GenresUseCase {
//    func fetchGenres() -> AnyPublisher<[Genre], Error>
}

public final class GenresUseCaseImpl: GenresUseCase {
    private let genreRepository: GenresRepositoryProtocol
    
    init(genreRepository: GenresRepositoryProtocol) {
        self.genreRepository = genreRepository
    }
    
//    func fetchGenres() -> AnyPublisher<[Genre], Error> {
//        
//    }
}

public final class GenresUseCaseMock: GenresUseCase {
//    func fetchGenres() -> AnyPublisher<[Genre], Error> {
//        
//    }
}
