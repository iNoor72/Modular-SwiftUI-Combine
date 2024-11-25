//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer

public enum MovieDetailsEndpoint: Endpoint {
    case movieDetails(id: Int)
    
    public var path: String {
        switch self {
        case .movieDetails(let id):
            return "movie/\(id)"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
}
