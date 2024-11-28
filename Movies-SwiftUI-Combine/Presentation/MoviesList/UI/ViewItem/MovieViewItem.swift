//
//  MovieViewItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 27/11/2024.
//

import Foundation

public struct MovieViewItem: Identifiable, Hashable {
    public let id: Int
    let uuid: UUID
    let title: String
    var releaseDate: String {
        didSet {
            releaseDate = releaseDate.components(separatedBy: "-").first ?? ""
        }
    }
    let posterPath: String?
}
