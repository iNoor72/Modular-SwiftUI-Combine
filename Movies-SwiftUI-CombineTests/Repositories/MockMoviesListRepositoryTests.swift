//
//  MockMoviesListRepositoryTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import Combine
import NetworkLayer
import CachingLayer
@testable import Movies_SwiftUI_Combine

final class MockMoviesListRepositoryTests: XCTestCase {
    var sut: MoviesListRepositoryProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockMoviesListRepository()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchMovies() {
        let expectation = XCTestExpectation(description: "executeFetchMoviesFromMoviesListRepository")
        sut.fetchMovies(with: 1, genreIDs: [])
            .sink { comp in
                if comp == .finished {
                    expectation.fulfill()
                    return
                }
                
                XCTFail("UseCase execute failed!")
            } receiveValue: { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10.0)
    }
}
