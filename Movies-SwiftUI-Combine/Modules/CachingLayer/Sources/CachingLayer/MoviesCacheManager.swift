//
//  File.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import Foundation
import CoreData

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
        do {
            managedObjectContext.insertedObjects.forEach {
                managedObjectContext.delete($0)
            }
            
            try managedObjectContext.save()
        } catch {
            NSLog("Unresolved error deleting then saving context: \(error)")
        }
    }
    
    public func fetchAllObjects<T: NSManagedObject>(_ type: T.Type) -> [NSFetchRequestResult] {
        let fetchRequest = type.fetchRequest()
        let result = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                      managedObjectContext: managedObjectContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
        return result.fetchedObjects ?? []
    }
    
    public func fetchObject<T: NSManagedObject>(_ type: T.Type, with id: String) -> T? {
        return nil
    }
    public func deleteObject<T: NSManagedObject>(_ type: T.Type, with id: String) -> T? {
        return nil
    }
}
