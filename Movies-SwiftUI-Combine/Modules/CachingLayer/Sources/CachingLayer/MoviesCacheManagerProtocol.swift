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
    func fetchAllObjects<T: NSManagedObject>(_ type: T.Type) -> [NSFetchRequestResult]
    func fetchObject<T: NSManagedObject>(_ type: T.Type, with id: String) -> T?
    func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: String) -> T?
    func clearCache()
}
