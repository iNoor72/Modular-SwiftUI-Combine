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
    @Published var searchQuery: String = ""
    @Published var debounceValue = ""
    private var page: Int = 1
    private var totalPages: Int = 1 {
        didSet {
            hasMoreRows = page < totalPages
        }
    }
    
    var selectedGenres: [GenreItem] = []
    var movies: [MoviesResponseItem] = []
    var searchedMovies: [MoviesResponseItem] = []
    var filteredMovies: [MoviesResponseItem] = []
    var genres: [GenreItem] = []
    var hasMoreRows = false
    var isSearching = false
    private let dependencies: MoviesListDependencies
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: MoviesListDependencies) {
        self.dependencies = dependencies
        $searchQuery
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .assign(to: &$debounceValue)
    }
    
    func handle(_ event: MoviesListEvents) {
        switch event {
        case .loadData:
            onAppear()
        case .loadMoreData:
            loadMoreMovies()
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
    
    func validatePagination(with movie: MoviesResponseItem) {
        let movies = isSearching ? searchedMovies : movies
        if let lastMovie = movies.last, movie.id == lastMovie.id {
            loadMoreMovies()
        }
    }
    
    private func loadMoreMovies() {
        guard hasMoreRows else {
            return
        }
        
        page += 1
        
        if isSearching {
            searchMovies(page: page)
        } else {
            fetchMovies(page: page)
        }
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
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .failure(error)
                }
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
                if genres.isEmpty {
                    self?.movies.append(contentsOf: moviesResponse.results ?? [])
                } else {
                    self?.filteredMovies = moviesResponse.results ?? []
                }
                
                self?.totalPages = moviesResponse.totalPages ?? 1
//                self?.dependencies.trendingMoviesUseCase.cache(self?.movies ?? [])
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func clearSearch() {
        page = 1
        selectedGenres = []
        searchedMovies = []
        searchQuery = ""
        isSearching = false
        state = .success
    }
    
    private func searchMovies(page: Int = 1) {
        isSearching = true
        
        guard !searchQuery.isEmpty else {
            clearSearch()
            return
        }
        
        dependencies.searchUseCase.execute(page: page, query: searchQuery)
            .receive(on: DispatchQueue.main)
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .sink {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .failure(error)
                }
            } receiveValue: {[weak self] response in
                self?.searchedMovies = response.results ?? []
                self?.totalPages = response.totalPages ?? 1
                self?.state = .searching
            }.store(in: &cancellables)
    }
}
