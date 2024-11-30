//
//  MockSearchRepositoryTests.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 29/11/2024.
//


import XCTest
import Combine
import NetworkLayer
import CachingLayer
@testable import Movies_SwiftUI_Combine

final class MockSearchRepositoryTests: XCTestCase {
    var sut: SearchRepositoryProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockSearchRepository()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_searchMovies() {
        let expectation = XCTestExpectation(description: "executeSearchMoviesFromSearchRepository")
        sut.searchMovies(page: 1, query: "")
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
