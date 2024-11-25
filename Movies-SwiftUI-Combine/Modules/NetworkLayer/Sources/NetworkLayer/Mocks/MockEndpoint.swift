//
//  File.swift
//  
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public enum MockEndpoint: Endpoint {
    case mock
    
    public var base: String {
        return "https://mock.com"
    }
    
    public var path: String {
        return "/test"
    }
    
    public var queryItems: [URLQueryItem] {
        return []
    }
    
    public var method: HTTPMethod {
        return .get
    }
}
