//
//  MovieDetailsFactory.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit
import SwiftUI
import NetworkLayer
import CachingLayer

protocol MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController
}

final class MovieDetailsFactory: MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController {
        let network = NetworkManager.shared
        let cache = MoviesCacheManager.shared
        
        let movieDetailsRepository = MovieDetailsRepository(network: network, cache: cache)
        let movieDetailsUseCase = MovieDetailsUseCaseImpl(movieDetailsRepository: movieDetailsRepository)
        let movieDetailsViewModel = MovieDetailsViewModel(movieId: movieID, movieDetailsUseCase: movieDetailsUseCase)
        let router = MovieDetailsRouter()
        
        let movieDetailsView = MovieDetailsScreen(viewModel: movieDetailsViewModel)
        
        let hostingViewController = UIHostingController(rootView: movieDetailsView)
        
        router.viewController = hostingViewController
        
        return hostingViewController
    }
}
