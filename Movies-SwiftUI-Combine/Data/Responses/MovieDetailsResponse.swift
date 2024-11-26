//
//  MovieDetailsResponse.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MovieDetailsResponse: Codable {
    public let id: Int?
    public let title: String?
    public let budget: Int?
    public let posterPath: String?
    public var releaseDate: String? {
        didSet {
            releaseDate = releaseDate?.components(separatedBy: "-").first ?? ""
        }
    }
    public let backdropPath: String?
    public let overview: String?
    public let homepage: String?
    public var spokenLanguages: [SpokenLanguageItem]?
    public let status: String?
    public let runtime: Int?
    public let genres: [GenreItem]?
    
    enum CodingKeys: String, CodingKey {
        case id, budget, status, runtime, genres, homepage, overview
        case title
        case spokenLanguages = "spoken_languages"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    static let dummyData = MovieDetailsResponse(id: nil, title: nil, budget: nil, posterPath: nil, releaseDate: nil, backdropPath: nil, overview: nil, homepage: nil, spokenLanguages: nil, status: nil, runtime: nil, genres: nil)
}

public struct SpokenLanguageItem: Codable {
    public let name: String?
}
