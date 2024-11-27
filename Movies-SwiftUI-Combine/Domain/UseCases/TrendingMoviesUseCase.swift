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
    func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<[MovieViewItem]?, NetworkError>
    func getCachedMovies() -> [MovieViewItem]
}

public final class TrendingMoviesUseCaseImpl: TrendingMoviesUseCase {
    private let moviesListRepository: MoviesListRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(moviesListRepository: MoviesListRepositoryProtocol) {
        self.moviesListRepository = moviesListRepository
    }
    
    public func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<[MovieViewItem]?, NetworkError> {
        Future<[MovieViewItem]?, NetworkError> {[weak self] promise in
            guard let self else { return }
            
            moviesListRepository
                .fetchMovies(with: page, genreIDs: genres.compactMap { $0.id })
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { comp in
                    
                }, receiveValue: { movieModels in
                    guard let movieModels else { return }
                    
                    let movies = movieModels.map(self.toMovieViewItem)
                    promise(.success(movies))
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
    private func toMovieViewItem(_ movie: MovieModel) -> MovieViewItem {
        MovieViewItem(id: Int(movie.id), title: movie.title ?? "", releaseDate: movie.releaseDate ?? "", posterPath: movie.posterPath)
    }
}

public final class TrendingMoviesUseCaseMock: TrendingMoviesUseCase {
    public func execute(page: Int, genres: [GenreItem]) -> AnyPublisher<[MovieViewItem]?, NetworkError> {
        Future<[MovieViewItem]?, NetworkError> { promise in
            promise(.success([]))
        }.eraseToAnyPublisher()
    }
    
    public func getCachedMovies() -> [MovieViewItem] {
     []
    }
}
