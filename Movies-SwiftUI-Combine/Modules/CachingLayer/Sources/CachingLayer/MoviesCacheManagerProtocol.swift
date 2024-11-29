//
//  MovieCacheManagerProtocol.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import CoreData

public protocol MovieCacheManagerProtocol {
    var managedObjectContext: NSManagedObjectContext { get }
    
    func save()
    func clearCache()
    func addObject<T: NSManagedObject>(_ objectID: String, _ object: T?, _ type: T.Type)
    func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: NSManagedObjectID) throws
    func fetch<T: NSManagedObject>(_ type: T.Type, with request: NSFetchRequest<T>) throws -> [T]
}
