//
//  SearchMoviesUseCase.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

protocol SearchMoviesUseCase {
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponseViewItem?, NetworkError>
}

final class SearchMoviesUseCaseImpl: SearchMoviesUseCase {
    private let repository: SearchRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponseViewItem?, NetworkError> {
        Future<MoviesResponseViewItem?, NetworkError> {[weak self] promise in
            guard let self else { return }
            repository.searchMovies(page: page, query: query)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { comp in
                    promise(.failure(NetworkError.failedRequest))
                }, receiveValue: { [weak self] movieResponse in
                    guard let self, let movieResponse else { return }
                    
                    let response = toMoviesResponseViewItem(movieResponse)
                    promise(.success(response))
                })
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension SearchMoviesUseCaseImpl {
    private func toMoviesResponseViewItem(_ response: MoviesResponseModel) -> MoviesResponseViewItem {
        let movies = response.movies?.compactMap { movie -> MovieViewItem? in
            guard let movie = movie as? MovieModel else {
                return nil
            }
            
            return toMovieViewItem(movie)
        }
        
        return MoviesResponseViewItem(totalPages: Int(response.totalPages), movies: movies ?? [])
    }
    
    private func toMovieViewItem(_ movie: MovieModel) -> MovieViewItem {
        MovieViewItem(
            id: movie.movieID ?? "",
            uuid: movie.uuid ?? UUID(),
            title: movie.title ?? "",
            releaseDate: movie.releaseDate?.components(separatedBy: "-").first ?? "",
            posterPath: movie.posterPath
        )
    }
}

final class SearchMoviesUseCaseMock: SearchMoviesUseCase {
    func execute(page: Int, query: String) -> AnyPublisher<MoviesResponseViewItem?, NetworkError> {
        Future<MoviesResponseViewItem?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
}
