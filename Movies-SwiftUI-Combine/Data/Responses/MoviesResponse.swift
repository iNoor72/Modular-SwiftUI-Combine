//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MoviesResponse: Codable {
    public let results: [MoviesResponseItem]?
    public let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
    
    static let dummyData = MoviesResponse(results: [], totalPages: nil)
}

public struct MoviesResponseItem: Codable, Hashable, Identifiable {
    public let id: Int?
    public let title: String?
    public var releaseDate: String? {
        didSet {
            releaseDate = releaseDate?.components(separatedBy: "-").first ?? ""
        }
    }
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
