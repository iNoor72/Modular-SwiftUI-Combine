//
//  TrendingMoviesUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

public protocol TrendingMoviesUseCase {
    func execute(page: Int, genres: [GenreViewItem]) -> AnyPublisher<MoviesResponseViewItem?, NetworkError>
    func getCachedMovies() -> [MovieViewItem]
}

public final class TrendingMoviesUseCaseImpl: TrendingMoviesUseCase {
    private let moviesListRepository: MoviesListRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(moviesListRepository: MoviesListRepositoryProtocol) {
        self.moviesListRepository = moviesListRepository
    }
    
    public func execute(page: Int, genres: [GenreViewItem]) -> AnyPublisher<MoviesResponseViewItem?, NetworkError> {
        Future<MoviesResponseViewItem?, NetworkError> {[weak self] promise in
            guard let self else { return }
            
            moviesListRepository
                .fetchMovies(with: page, genreIDs: genres.compactMap { $0.id })
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

    public func getCachedMovies() -> [MovieViewItem] {
        moviesListRepository.getCachedMovies()
            .map { toMovieViewItem($0) }
    }
}

extension TrendingMoviesUseCaseImpl {
    private func toMoviesResponseViewItem(_ response: MoviesResponseModel) -> MoviesResponseViewItem? {
        guard let movies = response.movies?.allObjects as? [MovieModel] else { return nil }
        let movieItems = movies.map(toMovieViewItem)
        
        return MoviesResponseViewItem(totalPages: Int(response.totalPages), movies: movieItems)
    }
    
    private func toMovieViewItem(_ movie: MovieModel) -> MovieViewItem {
        MovieViewItem(id: Int(movie.id), uuid: movie.uuid ?? UUID(), title: movie.title ?? "", releaseDate: movie.releaseDate ?? "", posterPath: movie.posterPath)
    }
}

public final class TrendingMoviesUseCaseMock: TrendingMoviesUseCase {
    public func execute(page: Int, genres: [GenreViewItem]) -> AnyPublisher<MoviesResponseViewItem?, NetworkError> {
        Future<MoviesResponseViewItem?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
    
    public func getCachedMovies() -> [MovieViewItem] {
     []
    }
}
