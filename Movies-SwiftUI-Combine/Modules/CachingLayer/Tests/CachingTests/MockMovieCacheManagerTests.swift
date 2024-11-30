//
//  MockMovieCacheManagerTests.swift
//  CachingLayer
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import CoreData
@testable import CachingLayer

final class MockMovieCacheManagerTests: XCTestCase {
    
    var sut: MovieCacheManagerProtocol!

    override func setUp() {
        super.setUp()
        sut = MoviesCacheManagerMock.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_save() {
        sut.save()
        
        XCTAssertTrue((sut as! MoviesCacheManagerMock).isSavedCalled)
    }
    
    func test_addObject() {
        sut.addObject(nil, NSManagedObject.self)
        
        XCTAssertEqual((sut as! MoviesCacheManagerMock).data.count, 1)
    }
    
    func test_fetch() {
        do {
            let result = try sut.fetch(NSManagedObject.self, with: NSFetchRequest<NSManagedObject>())
            XCTAssertTrue(result.isEmpty)
        } catch {
            XCTFail("Unexpected error fetching object, error: \(error)")
        }
    }
    
    func test_clearCache() {
        sut.clearCache()
        
        XCTAssertFalse((sut as! MoviesCacheManagerMock).isSavedCalled)
    }
    
    func test_deleteObject() {
        do {
            try sut.deleteObject(NSManagedObject.self, with: NSManagedObjectID.init())
            
            XCTAssertTrue((sut as! MoviesCacheManagerMock).isDeleteCalled)
        } catch {
            XCTFail("Unexpected error deleting object, error: \(error)")
        }
    }

}
