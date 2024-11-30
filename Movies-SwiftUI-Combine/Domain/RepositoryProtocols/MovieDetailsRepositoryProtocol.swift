//
//  MovieDetailsRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

protocol MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(with movieId: Int) -> AnyPublisher<MovieDetailsModel?, NetworkError>
    func getCachedMovieDetails(with id: String) -> MovieDetailsModel?
}
