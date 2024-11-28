//
//  MovieDetailsUseCase.swift
//  DomainLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine
import NetworkLayer
import CachingLayer

public protocol MovieDetailsUseCase {
    func execute(with movieId: Int) -> AnyPublisher<MovieDetailsViewItem?, NetworkError>
}

public final class MovieDetailsUseCaseImpl: MovieDetailsUseCase {
    private let movieDetailsRepository: MovieDetailsRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(movieDetailsRepository: MovieDetailsRepositoryProtocol) {
        self.movieDetailsRepository = movieDetailsRepository
    }
    
    public func execute(with movieId: Int) -> AnyPublisher<MovieDetailsViewItem?, NetworkError> {
        Future<MovieDetailsViewItem?, NetworkError> {[weak self] promise in
            guard let self else { return }
            
            movieDetailsRepository.fetchMovieDetails(with: movieId)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { comp in
                    promise(.failure(NetworkError.failedRequest))
                }, receiveValue: { [weak self] movieResponse in
                    guard let self, let movieResponse else { return }
                    
                    let response = toMovieDetailsViewItem(movieResponse)
                    promise(.success(response))
                })
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
}

extension MovieDetailsUseCaseImpl {
    private func toMovieDetailsViewItem(_ movieDetails: MovieDetailsModel) -> MovieDetailsViewItem? {
        guard
            let spokenLanguages = movieDetails.spokenLanguages?.allObjects as? [String],
            let genres = movieDetails.genres?.allObjects as? [GenreModel]
        else {
            return nil
        }
        
        let spokenLanguagesViewItems = spokenLanguages.map(toSpokenLanguageViewItem)
        let genresViewItems = genres.map(toGenreViewItem)
        
        return MovieDetailsViewItem(
            uuid: movieDetails.uuid ?? UUID(),
            id: Int(movieDetails.id),
            title: movieDetails.title,
            budget: Int(movieDetails.budget),
            posterPath: movieDetails.posterPath,
            releaseDate: movieDetails.releaseDate?.components(separatedBy: "-").first ?? "",
            backdropPath: movieDetails.backdropPath,
            overview: movieDetails.overview,
            homepage: movieDetails.homepage,
            spokenLanguages: spokenLanguagesViewItems,
            status: movieDetails.status,
            runtime: Int(movieDetails.runtime),
            genres: genresViewItems
        )
    }
    
    private func toGenreViewItem(_ genre: GenreModel) -> GenreViewItem {
        GenreViewItem(id: Int(genre.id), name: genre.name ?? "")
    }
    
    private func toSpokenLanguageViewItem(_ spokenLanguage: String) -> SpokenLanguageViewItem {
        SpokenLanguageViewItem(
            name: spokenLanguage
        )
    }
}

public final class MovieDetailsUseCaseMock: MovieDetailsUseCase {
    public func execute(with movieId: Int) -> AnyPublisher<MovieDetailsViewItem?, NetworkError> {
        Future<MovieDetailsViewItem?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
}
