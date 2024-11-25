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
}

public struct SpokenLanguageItem: Codable {
    public let name: String?
}
