//
//  MovieDetailsRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer

protocol MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetailsResponse, NetworkError>
}
