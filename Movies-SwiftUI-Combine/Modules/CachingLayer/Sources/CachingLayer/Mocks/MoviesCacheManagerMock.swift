//
//  File.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import Foundation
import CoreData

public final class MoviesCacheManagerMock {
    nonisolated(unsafe) public static let shared = MoviesCacheManagerMock()
    
    public var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    public var isSavedCalled: Bool = false
    public var data: [String] = []
    
    private init() {}
}

extension MoviesCacheManagerMock: MovieCacheManagerProtocol {
    public func addObject(_ object: NSManagedObject?) {
        data.append("")
    }
    
    public func fetch<T>(_ type: T.Type, with request: NSFetchRequest<T>) -> [T] where T : NSManagedObject {
        []
    }

    public func save() {
        isSavedCalled = true
    }
    
    public func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: NSManagedObjectID) throws -> T? {
        nil
    }
    
    public func clearCache() {
        isSavedCalled = false
    }
}
