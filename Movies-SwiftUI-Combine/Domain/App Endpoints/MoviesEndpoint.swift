//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer

public enum MoviesEndpoint: Endpoint {
    case trending(page: Int, genreIDs: [Int])
    
    public var path: String {
        switch self {
        case .trending:
            return "/discover/movie"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var queryParams: [String: String]? {
        switch self {
        case .trending(let page, let genres):
            return [
                "api_key": AppConfiguration.apiKey,
                "include_adult": 0.description,
                "sort_by": "popularity.desc",
                "page": page.description,
//                "with_genres": genres.map { $0.description }.joined(separator: ",")
            ]
        }
    }
}
