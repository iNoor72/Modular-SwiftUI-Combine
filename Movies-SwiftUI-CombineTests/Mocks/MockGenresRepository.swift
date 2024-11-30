//
//  MockGenresRepository.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import Foundation
import NetworkLayer
import CachingLayer
import Combine
@testable import Movies_SwiftUI_Combine

final class MockGenresRepository: GenresRepositoryProtocol {
    func fetchGenres() -> AnyPublisher<[GenreViewItem], NetworkLayer.NetworkError> {
        return Future<[GenreViewItem], NetworkError> { promise in
            promise(.success([]))
        }.eraseToAnyPublisher()
    }
}
