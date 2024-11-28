//
//  MovieDetailsViewItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import Foundation

public struct MovieDetailsViewItem: Identifiable, Hashable {
    public let uuid: UUID
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
    public var spokenLanguages: [SpokenLanguageViewItem]?
    public let status: String?
    public let runtime: Int?
    public let genres: [GenreViewItem]?
    
}
