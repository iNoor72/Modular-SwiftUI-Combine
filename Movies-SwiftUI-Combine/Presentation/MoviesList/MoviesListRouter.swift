//
//  MoviesListRouter.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit
import SwiftUI

protocol MoviesListRouterProtocol {
    func navigate(to destination: MoviesListDestination)
}

enum MoviesListDestination {
    case movieDetails(Movie)
}

final class MoviesListRouter: MoviesListRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigate(to destination: MoviesListDestination) {
        switch destination {
        case .movieDetails(let movie):
            navigateToMovieDetails(movie)
        }
    }
}

extension MoviesListRouter {
    private func navigateToMovieDetails(_ movie: Movie) {
        let movieDetailsFactory = MovieDetailsFactory()
        let movieDetailsView = movieDetailsFactory.make(with: 0)
        viewController?.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
}