//
//  MovieDetailsFactory.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import UIKit

protocol MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController
}

final class MovieDetailsFactory: MovieDetailsFactoryProtocol {
    func make(with movieID: Int) -> UIViewController {
        return UIViewController()
    }
}
