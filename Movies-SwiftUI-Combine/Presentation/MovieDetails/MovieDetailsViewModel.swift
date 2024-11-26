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
}

enum MovieDetailsScreenState {
    case initial
    case loading
    case success
    case failure(Error)
}

final class MovieDetailsViewModel: ObservableObject {
    @Published var state: MovieDetailsScreenState = .initial
    @Published var movieDetails: MovieDetailsResponse?
    
    private let movieDetailsUseCase: MovieDetailsUseCase
    private let movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int, movieDetailsUseCase: MovieDetailsUseCase) {
        self.movieId = movieId
        self.movieDetailsUseCase = movieDetailsUseCase
    }
    
    func handle(_ event: MoviesDetailsEvents) {
        switch event {
        case .loadData:
            onAppear()
        }
    }
    
    private func onAppear() {
        fetchDetails()
    }
    
    private func fetchDetails() {
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
                self?.movieDetails = response
                self?.state = .success
            }
            .store(in: &cancellables)
    }
}
