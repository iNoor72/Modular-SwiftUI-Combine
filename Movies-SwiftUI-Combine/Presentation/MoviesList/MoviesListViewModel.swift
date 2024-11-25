//
//  MoviesListViewModel.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

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
    
    private let genresUseCase: GenresUseCase
    private let trendingMoviesUseCase: TrendingMoviesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        genresUseCase: GenresUseCase,
        trendingMoviesUseCase: TrendingMoviesUseCase
    ) {
        self.genresUseCase = genresUseCase
        self.trendingMoviesUseCase = trendingMoviesUseCase
    }
    
    func onAppear() {
        fetchGenres()
        fetchMovies(page: page)
    }
    
    func loadMoreMovies() {
        fetchMovies(page: page + 1)
    }
    
    func didSelectGenreAction(genre: GenreItem) {
        selectedGenres.append(genre)
        fetchMovies(page: page, genres: selectedGenres)
    }
    
    private func fetch() {
        state = .loading
        let movies = trendingMoviesUseCase.execute(page: page, genres: selectedGenres)
        let genres = genresUseCase.execute()
        let _ = Publishers.Zip(movies, genres)
            .map { [weak self] (moviesResponse, genresResponse) in
                self?.movies = moviesResponse.results ?? []
                self?.genres = genresResponse.genres ?? []
                self?.state = .success
            }
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
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] moviesResponse in
                self?.movies = moviesResponse.results ?? []
                self?.state = .success
            }).store(in: &cancellables)
    }
}
