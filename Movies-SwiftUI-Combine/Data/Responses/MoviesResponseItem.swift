//
//  MoviesResponseItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 27/11/2024.
//

import Foundation
import CoreData
import CachingLayer

public struct MoviesResponseItem: Codable, Hashable, Identifiable {
    public let uuid = UUID()
    public let id: Int?
    public let title: String?
    public var releaseDate: String?
    public let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
    
    public func toMovieModel(context: NSManagedObjectContext) -> MovieModel {
        let model = MovieModel(context: context)
        model.uuid = UUID()
        model.id = Int64(id ?? 0)
        model.title = title ?? ""
        model.releaseDate = releaseDate ?? ""
        model.posterPath = posterPath ?? ""
        
        return model
    }
}
