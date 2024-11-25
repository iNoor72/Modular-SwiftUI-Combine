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
        
        let genresUseCase = GenresUseCaseImpl(genreRepository: genresRepository)
        let trendingMoviesUseCase = TrendingMoviesUseCaseImpl(moviesListRepository: moviesListRepository)
        
        let router = MoviesListRouter()
        
        let moviesListViewModel = MoviesListViewModel(
            genresUseCase: genresUseCase,
            trendingMoviesUseCase: trendingMoviesUseCase
        )
        
        let usersListView = MoviesListScreen(viewModel: moviesListViewModel)
        let hostingViewController = UIHostingController(rootView: usersListView)
        let navigationController = UINavigationController(rootViewController: hostingViewController)
        
        hostingViewController.navigationItem.title = "Movies"
        
        router.viewController = hostingViewController
        
        return navigationController
    }
}
