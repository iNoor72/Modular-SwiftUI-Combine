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
    
    func fetchGenres() -> AnyPublisher<[GenreViewItem], NetworkError> {
        do {
            let endpoint = GenresEndpoint.genres
            return try network
                .fetch(endpoint: endpoint, expectedType: GenresResponse.self)
                .map {
                    let viewItems = $0.genres?.map { $0.toGenreViewItem() } ?? []
                    return viewItems
                }
                .eraseToAnyPublisher()
        } catch {
            return Future<[GenreViewItem], NetworkError> { promise in
                promise(.failure(NetworkError.decodingError))
            }.eraseToAnyPublisher()
        }
    }
}
