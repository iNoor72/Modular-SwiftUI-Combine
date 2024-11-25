//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MoviesResponse: Codable {
    public let results: [MoviesResponseItem]?
    
    
    func toDataModel() -> DataModel? {
        return nil
    }
}

public struct MoviesResponseItem: Codable, Hashable, Identifiable {
    public let id: Int
}
