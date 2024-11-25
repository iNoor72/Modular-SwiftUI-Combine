//
//  NetworkError.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case noData
    case failedRequest
    case urlConstructionError
    
    public var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .decodingError:
            return "Decoding Error"
        case .noData:
            return "No Data"
        case .failedRequest:
            return "Failed Request"
        case .urlConstructionError:
            return "URL Construction Error"
        }
    }
}
