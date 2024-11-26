//
//  MoviesListViewModel.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

enum MoviesListEvents {
    case loadData
    case loadMoreData
    case didSelectGenre(GenreItem)
    case navigateToDetails(MoviesResponseItem)
}

enum MoviesListScreenState {
    case initial
    case loading
    case success
    case failure(Error)
}

final class MoviesListViewModel: ObservableObject {
    @Published var state: MoviesListScreenState = .initial
    @Published var movies: [MoviesResponseItem] = []
    @Published var genres: [GenreItem] = []
    @Published var searchQuery: String = ""
    @Published private var selectedGenres: [GenreItem] = []
    @Published private var page: Int = 1
    
    private let router: MoviesListRouterProtocol
    private let genresUseCase: GenresUseCase
    private let trendingMoviesUseCase: TrendingMoviesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        router: MoviesListRouterProtocol,
        genresUseCase: GenresUseCase,
        trendingMoviesUseCase: TrendingMoviesUseCase
    ) {
        self.router = router
        self.genresUseCase = genresUseCase
        self.trendingMoviesUseCase = trendingMoviesUseCase
    }
    
    func handle(_ event: MoviesListEvents) {
        switch event {
        case .loadData:
            onAppear()
        case .loadMoreData:
            loadMoreMovies()
        case .didSelectGenre(let genre):
            didSelectGenreAction(genre: genre)
        case .navigateToDetails(let movieItem):
            router.navigate(to: .movieDetails(movieItem))
        }
    }
    
    private func onAppear() {
        fetchGenres()
        fetchMovies(page: page)
    }
    
    private func loadMoreMovies() {
        fetchMovies(page: page + 1)
    }
    
    private func didSelectGenreAction(genre: GenreItem) {
        if selectedGenres.contains(genre) {
            if let index = selectedGenres.firstIndex(where: { $0.id == genre.id }) {
                selectedGenres.remove(at: index)
            }
        } else {
            selectedGenres.append(genre)
        }
        
        fetchMovies(page: page, genres: selectedGenres)
    }
    
    private func fetchGenres() {
        state = .loading
        
        genresUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] genresResponse in
                self?.genres = genresResponse.genres ?? []
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func fetchMovies(page: Int = 1, genres: [GenreItem] = []) {
        state = .loading
        
        trendingMoviesUseCase.execute(page: page, genres: genres)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .failure(error)
                }
            }, receiveValue: { [weak self] moviesResponse in
                self?.movies = moviesResponse.results ?? []
                self?.state = .success
            }).store(in: &cancellables)
    }
}
