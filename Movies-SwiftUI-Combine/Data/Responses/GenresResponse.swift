//
//  GenresResponse.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct GenresResponse: Codable {
    public let genres: [GenreItem]?
}

public struct GenreItem: Codable, Hashable, Identifiable {
    public let id: Int?
    public let name: String?
//    public var isSelected: Bool = false
//    
//    func toGenreModel() -> GenreModel? {
//        
//    }
}
