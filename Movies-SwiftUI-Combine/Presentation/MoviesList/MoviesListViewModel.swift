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

enum MoviesListScreenState: Int {
    case initial
    case success
    case searching
    case failure
}

final class MoviesListViewModel: ObservableObject {
    @Published var state: MoviesListScreenState = .initial
    @Published var searchQuery: String = ""
    @Published var debounceValue = ""
    @Published var isLoading = false
    @Published var movies: [MoviesResponseItem] = []
    var error: Error?
    private var page: Int = 1
    private var totalPages: Int = 1 {
        didSet {
            hasMoreRows = page < totalPages
        }
    }
    
    var selectedGenres: [GenreItem] = []
    var searchedMovies: [MoviesResponseItem] = []
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
        handle(.loadData)
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
        isLoading = true
        
        dependencies.genresUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.state = .failure
                }
            }, receiveValue: { [weak self] genresResponse in
                self?.genres = genresResponse.genres ?? []
                self?.isLoading = false
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func fetchMovies(page: Int = 1, genres: [GenreItem] = []) {
        isLoading = true
        
        dependencies.trendingMoviesUseCase.execute(page: page, genres: genres)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.state = .failure
                }
            }, receiveValue: { [weak self] moviesResponse in
                self?.movies.append(contentsOf: moviesResponse.results ?? [])
                self?.totalPages = moviesResponse.totalPages ?? 1
                self?.isLoading = false
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
                    self.error = error
                    self.state = .failure
                }
            } receiveValue: {[weak self] response in
                self?.searchedMovies = response.results ?? []
                self?.totalPages = response.totalPages ?? 1
                self?.state = .searching
            }.store(in: &cancellables)
    }
}
