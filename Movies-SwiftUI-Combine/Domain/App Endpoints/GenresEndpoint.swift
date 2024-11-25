//
//  GenresEndpoint.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer

enum GenresEndpoint: Endpoint {
    case genres
    
    var path: String {
        return "/genre/movie/list"
    }
    
    var method: NetworkLayer.HTTPMethod {
        .get
    }
    
}
