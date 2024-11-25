//
//  MovieDetailsViewModel.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

enum MovieDetailsScreenState {
    case initial
    case loading
    case success
    case failure(Error)
}

final class MovieDetailsViewModel: ObservableObject {
    @Published var state: MovieDetailsScreenState = .initial
    @Published var movieDetails: MovieDetails?
    
    private let movieDetailsUseCase: MovieDetailsUseCase
    private let movieId: Int
    
    init(movieId: Int, movieDetailsUseCase: MovieDetailsUseCase) {
        self.movieId = movieId
        self.movieDetailsUseCase = movieDetailsUseCase
    }
    
    func onAppear() {
        
    }
}
