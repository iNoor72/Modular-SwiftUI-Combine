//
//  NetworkErrors.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

enum NetworkErrors: Error {
    case urlRequestConstructionError
    case noInternet
    case failedToFetchData
}
