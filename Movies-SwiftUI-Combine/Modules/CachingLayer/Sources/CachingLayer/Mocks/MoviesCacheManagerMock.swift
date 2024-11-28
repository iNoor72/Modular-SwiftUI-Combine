//
//  File.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import Foundation
import CoreData

public final class MoviesCacheManagerMock {
    @MainActor public static let shared = MoviesCacheManagerMock()
    
    public var isSavedCalled: Bool = false
    
    private init() {}
}

extension MoviesCacheManagerMock: MovieCacheManagerProtocol {
    public var managedObjectContext: NSManagedObjectContext {
        NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }
    
    public func save() {
        isSavedCalled = true
    }
    
    public func fetchAllObjects<T>(_ type: T.Type) -> [any NSFetchRequestResult] where T : NSManagedObject {
        []
    }
    
    public func fetchObject<T>(_ type: T.Type, with id: String) -> T? where T : NSManagedObject {
        nil
    }
    
    public func deleteObject<T>(_ type: T.Type, with id: String) -> T? where T : NSManagedObject {
        nil
    }
    
    public func clearCache() {
        isSavedCalled = false
    }
    
    public func fetch<T>(_ type: T.Type, with request: NSFetchRequest<T>) -> [T] where T : NSManagedObject {
        []
    }
}
