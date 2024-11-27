//
//  MovieDetailsResponse.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import CoreData
import CachingLayer

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
    
    public func toMovieDetailsModel(context: NSManagedObjectContext) -> MovieDetailsModel {
        let entity = MovieDetailsModel(context: context)
        entity.id = Int64(id ?? 0)
        entity.uuid = UUID()
        entity.title = title
        entity.budget = Int64(budget ?? 0)
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.backdropPath = backdropPath
        entity.overview = overview
        entity.homepage = homepage
        entity.status = status
        entity.runtime = Int16(runtime ?? 0)
        entity.genres?.addingObjects(from: genres?.map { $0.toGenreModel(context: context) } ?? [])
        entity.spokenLanguages?.addingObjects(from: spokenLanguages?.map { $0.toSpokenLanguageModel(context: context)} ?? [])
        
        return entity
    }
}

public struct SpokenLanguageItem: Codable {
    public let name: String?
    
    public func toSpokenLanguageModel(context: NSManagedObjectContext) -> SpokenLanguageModel {
        let entity = SpokenLanguageModel(context: context)
        entity.name = name
        entity.uuid = UUID()
        
        return entity
    }
}
