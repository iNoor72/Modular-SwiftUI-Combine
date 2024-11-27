//
//  File.swift
//  DataLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import CoreData
import CachingLayer

public struct MoviesResponse: Codable {
    public let results: [MoviesResponseItem]?
    public let totalPages: Int?
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
    
    static let dummyData = MoviesResponse(results: [], totalPages: nil)
    
    func toMoviesResponseModel(context: NSManagedObjectContext) -> MoviesResponseModel {
        let model = MoviesResponseModel(context: context)
        model.totalPages = Int32(totalPages ?? 0)
        let movieModels = results?.map { $0.toMovieModel(context: context)} ?? []
        movieModels.forEach {
            model.addToMovies($0)
        }
        
        return model
    }
}
