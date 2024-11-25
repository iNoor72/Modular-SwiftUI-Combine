//
//  MovieDetailsFactory.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit
import SwiftUI

protocol MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController
}

final class MovieDetailsFactory: MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController {
        let movieDetailsRepository = MovieDetailsRepository()
        let movieDetailsUseCase = MovieDetailsUseCaseImpl(movieDetailsRepository: movieDetailsRepository)
        let movieDetailsViewModel = MovieDetailsViewModel(movieId: movieID, movieDetailsUseCase: movieDetailsUseCase)
        let router = MovieDetailsRouter()
        
        let movieDetailsView = MovieDetailsScreen(viewModel: movieDetailsViewModel)
        
        let hostingViewController = UIHostingController(rootView: movieDetailsView)
        let navigationController = UINavigationController(rootViewController: hostingViewController)
        
        router.viewController = hostingViewController
        
        return navigationController
    }
}
