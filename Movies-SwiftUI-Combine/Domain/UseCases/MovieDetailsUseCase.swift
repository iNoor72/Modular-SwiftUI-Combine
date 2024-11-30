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
    func getCachedMovieDetails(with id: String) -> MovieDetailsViewItem?
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
    
    public func getCachedMovieDetails(with id: String) -> MovieDetailsViewItem? {
        guard let movieDetails = movieDetailsRepository.getCachedMovieDetails(with: id) else { return nil }
            
        return toMovieDetailsViewItem(movieDetails)
    }
}

extension MovieDetailsUseCaseImpl {
    private func toMovieDetailsViewItem(_ movieDetails: MovieDetailsModel) -> MovieDetailsViewItem? {
        guard
            let spokenLanguages = movieDetails.spokenLanguages?.allObjects as? [SpokenLanguageModel],
            let genres = movieDetails.genres?.allObjects as? [GenreModel]
        else {
            return nil
        }
        
        let spokenLanguagesViewItems = spokenLanguages.compactMap(toSpokenLanguageViewItem)
        let genresViewItems = genres.compactMap(toGenreViewItem)
        
        return MovieDetailsViewItem(
            uuid: movieDetails.uuid ?? UUID(),
            id: movieDetails.movieID ?? "",
            title: movieDetails.title ?? "No title",
            budget: Int(movieDetails.budget),
            revenue: Int(movieDetails.revenue),
            posterPath: movieDetails.posterPath ?? "",
            releaseDate: movieDetails.releaseDate?.components(separatedBy: "-").first ?? "N/A",
            backdropPath: movieDetails.backdropPath ?? "",
            overview: movieDetails.overview ?? "No overview available.",
            homepage: movieDetails.homepage ?? "N/A",
            spokenLanguages: spokenLanguagesViewItems,
            status: movieDetails.status ?? "N/A",
            runtime: Int(movieDetails.runtime),
            genres: genresViewItems
        )
    }
    
    private func toGenreViewItem(_ genre: GenreModel) -> GenreViewItem {
        GenreViewItem(id: genre.genreID ?? "", name: genre.name ?? "")
    }
    
    private func toSpokenLanguageViewItem(_ spokenLanguage: SpokenLanguageModel) -> SpokenLanguageViewItem {
        SpokenLanguageViewItem(
            name: spokenLanguage.name ?? ""
        )
    }
}

public final class MovieDetailsUseCaseMock: MovieDetailsUseCase {
    public func execute(with movieId: Int) -> AnyPublisher<MovieDetailsViewItem?, NetworkError> {
        Future<MovieDetailsViewItem?, NetworkError> { promise in
            promise(.success(nil))
        }.eraseToAnyPublisher()
    }
    
    public func getCachedMovieDetails(with id: String) -> MovieDetailsViewItem? {
     nil
    }
}
