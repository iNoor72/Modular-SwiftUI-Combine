//
//  SpokenLanguageItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 27/11/2024.
//

import Foundation
import CoreData
import CachingLayer

public struct SpokenLanguageItem: Codable {
    public let name: String?
    
    public func toSpokenLanguageModel(context: NSManagedObjectContext) -> SpokenLanguageModel {
        let entity = SpokenLanguageModel(context: context)
        entity.name = name
        entity.uuid = UUID()
        
        return entity
    }
}
