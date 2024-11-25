//
//  Endpoint.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public protocol Endpoint {
    var baseURL: URL { get }
    var requestURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryParams: [String: String]? { get }
}

public extension Endpoint {
    var headers: [String: String]? { nil }
    var body: [String: Any]? { nil }
    var queryParams: [String: String]? { nil }
    
    var baseURL: URL {
        guard let url = URL(string: "https://" + AppConfiguration.baseURL) else {
            fatalError("Base URL is not set")
        }
        
        return url
    }
    
    var requestURL: URL {
        baseURL.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest? {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        if let queryParams = queryParams {
            var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = components?.url
        }
        
        return request
    }
}
