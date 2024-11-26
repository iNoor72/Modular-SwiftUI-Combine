//
//  SearchEndpoint.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import Foundation
import NetworkLayer

enum SearchEndpoint: Endpoint {
    case search(page: Int, query: String)
    
    var path: String {
        switch self {
        case .search:
            return "/search/movie"
        }
    }
    
    var method: NetworkLayer.HTTPMethod {
        .get
    }
    
    var queryParams: [String : String]? {
        switch self {
        case .search(let page, let query):
            return [
                "api_key": AppConfiguration.apiKey,
                "page": page.description,
                "query": query
            ]
        }
    }
    
}
