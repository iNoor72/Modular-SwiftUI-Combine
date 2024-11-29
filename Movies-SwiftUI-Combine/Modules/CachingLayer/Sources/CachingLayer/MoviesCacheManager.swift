//
//  File.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import CoreData
import SwiftUI

public final class MoviesCacheManager {
    @MainActor public static let shared = MoviesCacheManager()
    
    private init() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.module.url(forResource: AppConstants.CoreDataModelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()
    
    private(set) public lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

        return managedObjectContext
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(AppConstants.CoreDataModelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()
}

extension MoviesCacheManager: MovieCacheManagerProtocol {
    public func addObject<T: NSManagedObject>(_ objectID: String, _ object: T?, _ type: T.Type) {
        defer { save() }
        do {
            if didMovieModelsExceedMaxLimit() {
                guard let fetchRequest = type.fetchRequest() as? NSFetchRequest<T> else { return }
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                fetchRequest.fetchLimit = 1
                let fetchedItem = try fetch(type, with: fetchRequest).first
                
                //Skip if item is already saved. Sometimes TMDB returns same movies
                guard fetchedItem?.objectID != object?.objectID else { return }
                
                guard let firstItem = fetchedItem else { return }
                try deleteObject(type, with: firstItem.objectID)
                return
            }
        } catch {
            NSLog("Unresolved error adding object: \(error)")
        }
    }
    
    public func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
    public func clearCache() {
        managedObjectContext.insertedObjects.forEach {
            managedObjectContext.delete($0)
        }
        
        save()
    }
    
    public func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: NSManagedObjectID) throws {
        do {
            let request = type.fetchRequest()
            let objects = try managedObjectContext.fetch(request) as! [T]
            if let objectToDelete = objects.first(where: { $0.objectID === id }) {
                managedObjectContext.delete(objectToDelete)
            }
        } catch {
            NSLog("Unresolved error deleting then saving context: \(error)")
            throw error
        }
    }
    
    public func fetch<T: NSManagedObject>(_ type: T.Type, with request: NSFetchRequest<T>) throws -> [T] {
        do {
            let result = try managedObjectContext.fetch(request)
            return result
        } catch {
            NSLog("Unresolved error fetchin from context: \(error)")
            throw error
        }
    }
}

extension MoviesCacheManager {
    //I'm allowing the caching of 1000 records, this should be a fair number to allow a good user experience. However, Core Data doesn't set a limit for this unless you're caching data with enormous size (ex: BLOBs).
    private func didMovieModelsExceedMaxLimit() -> Bool {
        let modelsCount = managedObjectContext.registeredObjects.count
        return modelsCount >= AppConstants.maxCachedMoviesCount
    }
}
