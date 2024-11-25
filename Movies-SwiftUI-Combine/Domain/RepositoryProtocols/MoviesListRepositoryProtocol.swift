//
//  MoviesListRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

protocol MoviesListRepositoryProtocol {
    func fetchMovies(with page: Int, genreIDs: [Int]) -> AnyPublisher<MoviesResponse, NetworkError>
}
