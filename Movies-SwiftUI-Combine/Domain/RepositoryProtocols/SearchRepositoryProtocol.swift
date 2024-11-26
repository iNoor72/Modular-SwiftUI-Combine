//
//  SearchRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import Combine
import NetworkLayer

protocol SearchRepositoryProtocol {
    func searchMovies(page: Int, query: String) -> AnyPublisher<MoviesResponse, NetworkError>
}
