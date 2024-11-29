//
//  GenresResponse.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import CoreData
import CachingLayer

public struct GenresResponse: Codable {
    public let genres: [GenreResponseItem]?
    
    static let dummyData = GenresResponse(genres: [])
}

public struct GenreResponseItem: Codable, Hashable, Identifiable {
    public let id: Int?
    public let name: String?
    
    func toGenreModel(context: NSManagedObjectContext) -> GenreModel {
        let entity = GenreModel(context: context)
        entity.uuid = UUID()
        entity.genreID = (id ?? 0).toString
        entity.name = name ?? ""
        entity.isSelected = false
        
        return entity
    }
    
    func toGenreViewItem() -> GenreViewItem {
        GenreViewItem(id: (id ?? 0).toString, name: name ?? "")
    }
}
