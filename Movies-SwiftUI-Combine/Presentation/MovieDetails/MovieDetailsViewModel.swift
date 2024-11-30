//
//  MovieDetailsViewModel.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

enum MoviesDetailsEvents {
    case loadData
    case retryAction
    case resetError
    case networkChanged(Bool)
}

enum MovieDetailsScreenState {
    case initial
    case loading
    case success
    case offline
    case failure(Error)
}

final class MovieDetailsViewModel: ObservableObject {
    @Published var state: MovieDetailsScreenState = .initial
    @Published var movieDetails: MovieDetailsViewItem!
    @Published var isNetworkConnectionLost = false
    @Published var showErrorAlert = false
    var error: Error?
    
    private let networkMonitor: NetworkMonitorProtocol
    private let movieDetailsUseCase: MovieDetailsUseCase
    private let movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, movieDetailsUseCase: MovieDetailsUseCase, networkMonitor: NetworkMonitorProtocol) {
        self.networkMonitor = networkMonitor
        self.movieId = movieId
        self.movieDetailsUseCase = movieDetailsUseCase
        observeNetworkChanges()
    }
    
    func handle(_ event: MoviesDetailsEvents) {
        switch event {
        case .loadData:
            onAppear()
        case .networkChanged(let isConnected):
            handleNetworkChanging(isConnected)
        case .retryAction:
            didTapRetry()
        case .resetError:
            resetErrors()
        }
    }
    
    private func observeNetworkChanges() {
        networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                self.isNetworkConnectionLost = !isConnected
                handle(.networkChanged(isConnected))
            }
            .store(in: &cancellables)
    }
    
    private func onAppear() {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMovieDetailsOfflineFetching()
            return
        }
        
        fetchDetails()
    }
    
    private func fetchDetails() {
        guard isConnectedToNetwork() else {
            isNetworkConnectionLost = true
            handleMovieDetailsOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = true
        state = .loading
        
        movieDetailsUseCase.execute(with: movieId)
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .failure(error)
                }
            } receiveValue: { [weak self] response in
                guard let response else { return }
                
                self?.movieDetails = response
                self?.state = .success
            }
            .store(in: &cancellables)
    }
    
    private func handleNetworkChanging(_ isConnected: Bool) {
        guard isConnected else {
            isNetworkConnectionLost = true
            handleMovieDetailsOfflineFetching()
            return
        }
        
        isNetworkConnectionLost = false
        state = .initial
        handle(.loadData)
    }
    
    private func isConnectedToNetwork() -> Bool {
        !isNetworkConnectionLost
    }
    
    private func handleMovieDetailsOfflineFetching() {
        let movieDetails = movieDetailsUseCase.getCachedMovieDetails(with: movieId.toString)
        
        guard let movieDetails = movieDetails else {
            state = .failure(AppError.noDataAvailable)
            return
        }
        
        self.movieDetails = movieDetails
        state = .offline
    }
    
    private func didTapRetry() {
        state = .initial
        handle(.loadData)
    }
    
    private func resetErrors() {
        error = nil
        showErrorAlert = false
        didTapRetry()
    }
}
