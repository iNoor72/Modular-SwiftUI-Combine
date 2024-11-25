//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import NetworkLayer

public enum MoviesEndpoint: Endpoint {
    case genres
    case trending(page: Int)
    
    public var path: String {
        switch self {
        case .genres:
            return "/genre/movie/list"
        case .trending:
            return "/discover/movie"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var queryParams: [String : String]? {
        switch self {
        case .trending(let page):
            return [
                "include_adult" : 0.description,
                "sort_by" : "popularity.desc",
                "page" : page.description
            ]
        default:
            return nil
        }
    }
}
