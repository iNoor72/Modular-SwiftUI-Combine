//
//  GenresRepository.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer
import Combine

final class GenresRepository: GenresRepositoryProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    func fetchGenres() -> AnyPublisher<[GenreItem], NetworkError> {
        do {
            let endpoint = GenresEndpoint.genres
            return try network
                .fetch(endpoint: endpoint, expectedType: [GenreItem].self)
                .eraseToAnyPublisher()
        } catch {
            return Future<[GenreItem], NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
}
