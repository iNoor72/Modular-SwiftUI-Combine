//
//  MoviesListFactory.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI
import UIKit
import NetworkLayer

protocol MoviesListFactoryProtocol {
    func make() -> UIViewController
}

final class MoviesListFactory: MoviesListFactoryProtocol {
    func make() -> UIViewController {
        let genresRepository = GenresRepository(network: NetworkManager.shared)
        let moviesListRepository = MoviesListRepository(network: NetworkManager.shared)
        let searchingRepository = SearchRepository(network: NetworkManager.shared)
        
        let genresUseCase = GenresUseCaseImpl(genreRepository: genresRepository)
        let trendingMoviesUseCase = TrendingMoviesUseCaseImpl(moviesListRepository: moviesListRepository)
        let searchMoviesUseCase = SearchMoviesUseCaseImpl(repository: searchingRepository)
        
        let router = MoviesListRouter()
        
        let viewModelDependencies = MoviesListDependencies(
            router: router,
            genresUseCase: genresUseCase,
            trendingMoviesUseCase: trendingMoviesUseCase,
            searchUseCase: searchMoviesUseCase
        )
        
        let moviesListViewModel = MoviesListViewModel(dependencies: viewModelDependencies)
        
        let usersListView = MoviesListScreen(viewModel: moviesListViewModel)
        let hostingViewController = UIHostingController(rootView: usersListView)
        
        hostingViewController.navigationItem.title = "Movies"
        
        router.viewController = hostingViewController
        
        return hostingViewController
    }
}

struct MoviesListDependencies {
    let router: MoviesListRouterProtocol
    let genresUseCase: GenresUseCase
    let trendingMoviesUseCase: TrendingMoviesUseCase
    let searchUseCase: SearchMoviesUseCase
}
