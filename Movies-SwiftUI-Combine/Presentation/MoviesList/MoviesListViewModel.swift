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
    case resetError
    case retryAction
    case networkChanged(Bool)
    case paginate(MovieViewItem)
    case didSelectGenre(GenreViewItem)
    case navigateToDetails(MovieViewItem)
}

enum MoviesListScreenState: Int {
    case initial
    case success
    case searching
    case offline
}

final class MoviesListViewModel: ObservableObject {
    @Published var state: MoviesListScreenState = .initial
    @Published var searchQuery: String = ""
    @Published var debounceValue = ""
    @Published var isLoading = false
    @Published var isNetworkConnectionLost = false
    @Published var movies: [MovieViewItem] = []
    
    private var page: Int = 1
    private var totalPages: Int = 1 {
        didSet {
            hasMoreRows = page < totalPages
        }
    }
    
    var genres: [GenreViewItem] = []
    var selectedGenres: [GenreViewItem] = []
    var searchedMovies: [MovieViewItem] = []
    var filteredMovies: [MovieViewItem] = []
    
    var error: Error?
    var showErrorAlert = false
    var hasMoreRows = false
    var isSearching = false
    
    private let dependencies: MoviesListDependencies
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: MoviesListDependencies) {
        self.dependencies = dependencies
        $searchQuery
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .assign(to: &$debounceValue)
        observeNetworkChanges()
    }
    
    private func observeNetworkChanges() {
        dependencies.networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                self.isNetworkConnectionLost = !isConnected
                handle(.networkChanged(isConnected))
            }
            .store(in: &cancellables)
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
        case .resetError:
            resetErrors()
        case .retryAction:
            didTapRetry()
        case .networkChanged(let isConnected):
            handleNetworkChanging(isConnected)
        case .paginate(let movie):
            paginate(with: movie)
        case .didSelectGenre(let genre):
            didSelectGenreAction(genre: genre)
        case .navigateToDetails(let movieItem):
            dependencies.router.navigate(to: .movieDetails(movieItem))
        }
    }
    
    private func onAppear() {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
     
        fetchGenres()
        fetchMovies(page: page, genres: selectedGenres)
    }
    
    private func handleMoviesOfflineFetching() {
        let movies = dependencies.trendingMoviesUseCase.getCachedMovies()
        
        guard !movies.isEmpty else {
            showErrorAlert = true
            error = AppError.noDataAvailable
            return
        }
        
        self.movies = movies
        state = .offline
    }
    
    private func isConnectedToNetwork() -> Bool {
        if isNetworkConnectionLost { state = .offline }
        return !isNetworkConnectionLost
    }
    
    private func handleNetworkChanging(_ isConnected: Bool) {
        movies = []
        state = .initial
        
        guard isConnected else {
            state = .offline
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        handle(.loadData)
    }
    
    private func resetErrors() {
        error = nil
        showErrorAlert = false
        didTapRetry()
    }
    
    private func paginate(with movie: MovieViewItem) {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        let movies = isSearching ? searchedMovies : (selectedGenres.isEmpty ? movies : filteredMovies)
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
            fetchMovies(page: page, genres: selectedGenres, appendNewResults: !selectedGenres.isEmpty)
        }
    }
    
    private func fetchGenres() {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        isLoading = true
        
        dependencies.genresUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { [weak self] genres in
                self?.genres = genres
                self?.isLoading = false
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func fetchMovies(page: Int = 1, genres: [GenreViewItem] = [], appendNewResults: Bool = false) {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        isLoading = true
        
        dependencies.trendingMoviesUseCase.execute(page: page, genres: genres)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            }, receiveValue: { [weak self] moviesResponse in
                if genres.isEmpty {
                    self?.movies.append(contentsOf: moviesResponse?.movies ?? [])
                } else {
                    if appendNewResults {
                        self?.filteredMovies.append(contentsOf: moviesResponse?.movies ?? [])
                    } else {
                        self?.filteredMovies = moviesResponse?.movies ?? []
                    }
                }
                
                self?.totalPages = moviesResponse?.totalPages ?? 1
                self?.isLoading = false
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func searchMovies(page: Int = 1) {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMoviesOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        isSearching = true
        isLoading = true
        
        guard !searchQuery.isEmpty else {
            clearSearch()
            return
        }
        
        dependencies.searchUseCase.execute(page: page, query: searchQuery)
            .receive(on: DispatchQueue.main)
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .sink {[weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
            } receiveValue: {[weak self] moviesResponse in
                self?.searchedMovies.append(contentsOf: moviesResponse?.movies ?? [])
                self?.totalPages = moviesResponse?.totalPages ?? 1
                self?.isLoading = false
                self?.state = .success
            }.store(in: &cancellables)
    }
    
    private func didSelectGenreAction(genre: GenreViewItem) {
        let oldGenres = selectedGenres
        guard let genreIndex = genres.firstIndex(where: { $0.id == genre.id }) else { return }
        genres[genreIndex].isSelected.toggle()
        
        if genres[genreIndex].isSelected {
            selectedGenres.append(genre)
        } else {
            if let index = selectedGenres.firstIndex(where: { $0.id == genre.id }) {
                selectedGenres.remove(at: index)
            }
        }
        
        fetchMovies(page: page, genres: selectedGenres, appendNewResults: oldGenres == selectedGenres)
    }
    
    private func clearSearch() {
        page = 1
        selectedGenres = []
        searchedMovies = []
        searchQuery = ""
        debounceValue = ""
        isSearching = false
        state = .success
    }
    
    private func didTapRetry() {
        state = .initial
        handle(.loadData)
    }
}
