//
//  MockMoviesListRouter.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import UIKit
@testable import Movies_SwiftUI_Combine

final class MockMoviesListRouter: MoviesListRouterProtocol {
    var isNavigateCalled = false
    weak var viewController: UIViewController?
    
    func navigate(to destination: MoviesListDestination) {
        isNavigateCalled = true
    }
}
