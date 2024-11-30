//
//  GenreViewItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 27/11/2024.
//

import Foundation

public struct GenreViewItem: Hashable, Identifiable {
    public let uuid = UUID()
    public let id: String
    public let name: String
    public var isSelected: Bool = false
    
    mutating func toggleSelection() {
        isSelected.toggle()
    }
}
