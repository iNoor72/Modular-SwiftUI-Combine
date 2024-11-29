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
    func addObject(_ object: NSManagedObject?)
    func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: NSManagedObjectID) throws -> T?
    func fetch<T: NSManagedObject>(_ type: T.Type, with request: NSFetchRequest<T>) -> [T]
}
