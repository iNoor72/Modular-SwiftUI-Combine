//
//  MovieDetailsRouter.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import SwiftUI

enum MovieDetailsDestination {
    case newScreen
}

protocol MovieDetailsRouterProtocol {
    func navigate(to destination: MovieDetailsDestination)
}

final class MovieDetailsRouter: MovieDetailsRouterProtocol {
    weak var viewController: UIViewController?
    
    func navigate(to destination: MovieDetailsDestination) {
        switch destination {
        case .newScreen:
            navigateToNewScreen()
        }
    }
}

extension MovieDetailsRouter {
    private func navigateToNewScreen() {
        //Add implementation
    }
}
