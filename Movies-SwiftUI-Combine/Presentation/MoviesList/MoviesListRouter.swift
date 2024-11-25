//
//  MoviesListRouter.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit

enum Destination {
    case movieDetails(Movie)
}

protocol Router {
    func navigate(to destination: Destination)
}

//MARK: This is an implementation for UIKit-based Router, it provides more flexibility and more easier to use than SwiftUI router
final class MoviesListRouter: Router {
    weak var viewController: UIViewController?
    
    func navigate(to destination: Destination) {
        switch destination {
        case .movieDetails(let movie):
            navigateToMovieDetails(movie)
        }
    }
    
    private func navigateToMovieDetails(_ movie: Movie) {
        let movieDetailsFactory = MovieDetailsFactory()
        let movieDetailsView = movieDetailsFactory.make(with: 0)
        viewController?.navigationController?.pushViewController(movieDetailsView, animated: true)
    }
}
