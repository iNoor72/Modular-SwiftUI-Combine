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
    case paginate(MovieViewItem)
    case didSelectGenre(GenreViewItem)
    case navigateToDetails(MovieViewItem)
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
    @Published var isNetworkConnectionLost = false
    @Published var movies: [MovieViewItem] = []
    
    private var page: Int = 1
    private var totalPages: Int = 1 {
        didSet {
            hasMoreRows = page < totalPages
        }
    }
    
    let monitor = NetworkMonitor()
    
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
            resetSearch()
        case .paginate(let movie):
            paginate(with: movie)
        case .didSelectGenre(let genre):
            didSelectGenreAction(genre: genre)
        case .navigateToDetails(let movieItem):
            dependencies.router.navigate(to: .movieDetails(movieItem))
        }
    }
    
    private func onAppear() {
        checkNetworkConnection()
    private func checkNetworkConnection() {
        guard dependencies.networkMonitor.isConnected else {
            isNetworkConnectionLost = true
            movies = dependencies.trendingMoviesUseCase.getCachedMovies()
            return
        }
    }
    
    private func paginate(with movie: MovieViewItem) {
        let movies = isSearching ? searchedMovies : movies
        if let lastMovie = movies.last, movie.id == lastMovie.id {
            loadMoreMovies()
        }
    }
    
    private func resetSearch() {
        error = nil
        showErrorAlert = false
    }
    
    private func loadMoreMovies() {
        checkNetworkConnection()
        
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
    
    private func didSelectGenreAction(genre: GenreViewItem) {
        guard let genreIndex = genres.firstIndex(where: { $0.id == genre.id }) else { return }
        genres[genreIndex].isSelected.toggle()
        
        if genres[genreIndex].isSelected {
            selectedGenres.append(genre)
        } else {
            if let index = selectedGenres.firstIndex(where: { $0.id == genre.id }) {
                selectedGenres.remove(at: index)
            }
        }
        
        fetchMovies(page: page, genres: selectedGenres)
    }
    
    private func fetchGenres() {
        checkNetworkConnection()
        
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
            }, receiveValue: { [weak self] genres in
                self?.genres = genres
                self?.isLoading = false
                self?.state = .success
            }).store(in: &cancellables)
    }
    
    private func fetchMovies(page: Int = 1, genres: [GenreViewItem] = []) {
        checkNetworkConnection()
        
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
                if genres.isEmpty {
                    self?.movies.append(contentsOf: moviesResponse?.movies ?? [])
                } else {
                    self?.filteredMovies = moviesResponse?.movies ?? []
                }
                
                self?.totalPages = moviesResponse?.totalPages ?? 1
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
        checkNetworkConnection()
        
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
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    self.state = .failure
                }
            } receiveValue: {[weak self] moviesResponse in
                self?.searchedMovies.append(contentsOf: moviesResponse?.movies ?? [])
                self?.totalPages = moviesResponse?.totalPages ?? 1
                self?.isLoading = false
                self?.state = .success
            }.store(in: &cancellables)
    }
}
