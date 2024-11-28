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
        sut = MoviesCacheManagerMock.shared
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_save() {
        sut.save()
        
        XCTAssertTrue((sut as! MoviesCacheManagerMock).isSavedCalled)
    }
    
    func test_addObject() {
//        sut.addObject(MovieModel(context: sut.managedObjectContext))
//        
//        XCTAssertEqual((sut as! MoviesCacheManagerMock).data.count, 1)
    }
    
    func test_fetch() {
        let result = sut.fetch(NSManagedObject.self, with: NSFetchRequest<NSManagedObject>())
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_clearCache() {
        sut.clearCache()
        
        XCTAssertFalse((sut as! MoviesCacheManagerMock).isSavedCalled)
    }

}
