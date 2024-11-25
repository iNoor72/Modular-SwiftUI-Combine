//
//  GenreModel.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct GenreModel: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public var isSelected: Bool = false
}
