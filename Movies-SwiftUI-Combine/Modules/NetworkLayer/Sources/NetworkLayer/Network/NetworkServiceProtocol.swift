//
//  NetworkService.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import Combine

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable, U: Endpoint>(
        endpoint: U,
        expectedType: T.Type
    ) throws -> AnyPublisher<T, NetworkError>
}
