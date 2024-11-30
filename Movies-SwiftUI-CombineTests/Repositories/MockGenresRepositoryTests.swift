//
//  MockGenresRepositoryTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import XCTest
import Combine
import NetworkLayer
import CachingLayer
@testable import Movies_SwiftUI_Combine

final class MockGenresRepositoryTests: XCTestCase {
    var sut: GenresRepositoryProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockGenresRepository()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchGenres() {
        let expectation = XCTestExpectation(description: "executeFetchGenresFromGenresRepository")
        sut.fetchGenres()
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
