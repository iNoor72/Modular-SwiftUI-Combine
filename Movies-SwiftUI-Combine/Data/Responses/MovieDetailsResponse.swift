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
    public let revenue: Int?
    public let posterPath: String?
    public var releaseDate: String? 
    public let backdropPath: String?
    public let overview: String?
    public let homepage: String?
    public var spokenLanguages: [SpokenLanguageItem]?
    public let status: String?
    public let runtime: Int?
    public let genres: [GenreResponseItem]?
    
    enum CodingKeys: String, CodingKey {
        case id, budget, status, runtime, genres, homepage, overview, revenue
        case title
        case spokenLanguages = "spoken_languages"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    static let dummyData = MovieDetailsResponse(id: nil, title: nil, budget: nil, revenue: nil, posterPath: nil, releaseDate: nil, backdropPath: nil, overview: nil, homepage: nil, spokenLanguages: nil, status: nil, runtime: nil, genres: nil)
    
    public func toMovieDetailsModel(context: NSManagedObjectContext) -> MovieDetailsModel {
        let entity = MovieDetailsModel(context: context)
        entity.movieID = (id ?? 0).toString
        entity.creationDate = Date()
        entity.uuid = UUID()
        entity.title = title
        entity.budget = Int64(budget ?? 0)
        entity.revenue = Int64(revenue ?? 0)
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate
        entity.backdropPath = backdropPath
        entity.overview = overview
        entity.homepage = homepage
        entity.status = status
        entity.runtime = Int16(runtime ?? 0)
        
        genres?.forEach {
            let model = $0.toGenreModel(context: context)
            entity.addToGenres(model)
        }
        
        spokenLanguages?.forEach {
            let model = $0.toSpokenLanguageModel(context: context)
            entity.addToSpokenLanguages(model)
        }
        
        return entity
    }
}
