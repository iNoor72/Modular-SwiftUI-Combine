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
    @Published var state: MoviesListScreenState = .success
    @Published var movies: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var searchQuery: String = ""
    
    private let genresUseCase: GenresUseCase
    private let trendingMoviesUseCase: TrendingMoviesUseCase
    
    init(
        genresUseCase: GenresUseCase,
        trendingMoviesUseCase: TrendingMoviesUseCase
    ) {
        self.genresUseCase = genresUseCase
        self.trendingMoviesUseCase = trendingMoviesUseCase
    }
    
    func onAppear() {
        
    }
    
    func didSelectGenreAction() {
        
    }
}
