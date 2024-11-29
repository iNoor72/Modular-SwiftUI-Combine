//
//  MoviesListRouter.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit
import SwiftUI

protocol MoviesListRouterProtocol {
    var viewController: UIViewController? { get }
    
    func navigate(to destination: MoviesListDestination)
}

enum MoviesListDestination {
    case movieDetails(MovieViewItem)
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
    private func navigateToMovieDetails(_ movie: MovieViewItem) {
        let movieDetailsFactory = MovieDetailsFactory()
        let movieDetailsView = movieDetailsFactory.make(with: Int(movie.id))
        viewController?.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
}
