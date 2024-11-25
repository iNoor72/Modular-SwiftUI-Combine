//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MoviesResponse: Codable {
    public let results: [MoviesResponseItem]?
    
    static let dummyData = MoviesResponse(results: [])
}

public struct MoviesResponseItem: Codable, Hashable, Identifiable {
    public let id: Int?
    public let title: String?
    public let releaseDate: String?
    public let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
    
    func toMovieModel() -> MovieModel? {
        return MovieModel(
            id: id ?? 0,
            title: title ?? "",
            releaseDate: releaseDate ?? "",
            posterPath: posterPath ?? ""
        )
    }
}
