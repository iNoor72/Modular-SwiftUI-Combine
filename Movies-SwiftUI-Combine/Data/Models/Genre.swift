//
//  Genre.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation

public struct Genre: Identifiable, Hashable {
    public let id: String
    public let title: String
    public var isSelected: Bool = false
}
