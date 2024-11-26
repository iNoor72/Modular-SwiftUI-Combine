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
    case loadMoreData(MoviesResponseItem)
    case search
    case clearSearch
    case didSelectGenre(GenreItem)
    case navigateToDetails(MoviesResponseItem)
}

enum MoviesListScreenState {
    case initial
    case loading
    case success
    case searching
    case failure(Error)
}

final class MoviesListViewModel: ObservableObject {
    @Published var state: MoviesListScreenState = .initial
    @Published var movies: [MoviesResponseItem] = []
    @Published var searchedMovies: [MoviesResponseItem] = []
    @Published var genres: [GenreItem] = []
    @Published var searchQuery: String = ""
    @Published private var selectedGenres: [GenreItem] = []
    @Published private var page: Int = 1
    @Published private var totalPages: Int = 1 {
        didSet {
            hasMoreRows = page < totalPages
        }
    }
    
    var hasMoreRows = false
    private let dependencies: MoviesListDependencies
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: MoviesListDependencies) {
        self.dependencies = dependencies
    }
    
    func handle(_ event: MoviesListEvents) {
        switch event {
        case .loadData:
            onAppear()
        case .loadMoreData(let movie):
            loadMoreMovies(movie: movie)
        case .search:
            page = 1
            searchMovies()
        case .clearSearch:
            clearSearch()
        case .didSelectGenre(let genre):
            didSelectGenreAction(genre: genre)
        case .navigateToDetails(let movieItem):
            dependencies.router.navigate(to: .movieDetails(movieItem))
        }
    }
    
    private func onAppear() {
        fetchGenres()
        fetchMovies(page: page)
    }
    
    private func loadMoreMovies(movie: MoviesResponseItem) {
        let lastMovieID = self.movies.last?.id
        guard let lastMovieID, lastMovieID == movie.id, hasMoreRows else {
            return
        }
        
        page += 1
        fetchMovies(page: page)
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
        
        dependencies.genresUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] genresResponse in
                self?.genres = genresResponse.genres ?? []
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func fetchMovies(page: Int = 1, genres: [GenreItem] = []) {
        state = .loading
        
        dependencies.trendingMoviesUseCase.execute(page: page, genres: genres)
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
                self?.totalPages = moviesResponse.totalPages ?? 1
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func clearSearch() {
        page = 1
        selectedGenres = []
        searchedMovies = []
        searchQuery = ""
        state = .success
    }
    
    private func searchMovies(page: Int = 1) {
        guard !searchQuery.isEmpty else {
            self.state = .success
            return
        }
        
        dependencies.searchUseCase.execute(page: page, query: searchQuery)
            .receive(on: DispatchQueue.main)
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .sink { comp in
                print(comp)
            } receiveValue: {[weak self] response in
                self?.searchedMovies = response.results ?? []
                self?.totalPages = response.totalPages ?? 1
                self?.state = .searching
            }.store(in: &cancellables)
    }
}
