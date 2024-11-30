//
//  SearchRepositoryProtocol.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

protocol SearchRepositoryProtocol {
    func searchMovies(page: Int, query: String) -> AnyPublisher<MoviesResponseModel?, NetworkError>
}
