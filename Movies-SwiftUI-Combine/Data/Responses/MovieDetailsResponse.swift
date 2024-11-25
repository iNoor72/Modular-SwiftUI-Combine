//
//  MovieDetailsResponse.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct MovieDetailsResponse: Codable {
    public let id: Int?
    public let budget: Int?
    public let posterPath: String?
    public let backdropPath: String?
    public let overview: String?
    public let homepage: String?
    public let spokenLanguages: [SpokenLanguageItem]?
    public let status: String?
    public let runtime: Int?
    public let genres: [GenreItem]?
    
    static let dummyData = MovieDetailsResponse(id: nil, budget: nil, posterPath: nil, backdropPath: nil, overview: nil, homepage: nil, spokenLanguages: nil, status: nil, runtime: nil, genres: nil)
}

public struct SpokenLanguageItem: Codable {
    public let name: String?
}
