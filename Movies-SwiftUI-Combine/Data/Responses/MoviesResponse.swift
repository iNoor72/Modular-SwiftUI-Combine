//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MoviesResponse: Codable {
    public let results: [MoviesResponseItem]?
}

public struct MoviesResponseItem: Codable, Hashable, Identifiable {
    public let id: Int?
    public let title: String?
    public let releaseDate: String?
    public let posterPath: String?
    
    func toMovieModel() -> MovieModel? {
        return nil
    }
}
