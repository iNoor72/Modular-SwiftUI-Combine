//
//  GenresRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer
import Combine

protocol GenresRepositoryProtocol {
    func fetchGenres() -> AnyPublisher<[GenreItem], NetworkError>
}
