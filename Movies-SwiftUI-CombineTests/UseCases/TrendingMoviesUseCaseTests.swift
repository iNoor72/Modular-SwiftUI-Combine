//
//  TrendingMoviesUseCaseTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import Combine
@testable import Movies_SwiftUI_Combine

final class TrendingMoviesUseCaseTests: XCTestCase {
    var sut: TrendingMoviesUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        sut = TrendingMoviesUseCaseMock()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
    }
    
    func test_execute() {
        let expectation = XCTestExpectation(description: "executeTrendingMoviesUseCase")
        sut.execute(page: 1, genres: [])
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
    
    func test_getCachedMovies() {
        let movies = sut.getCachedMovies()
        XCTAssertTrue(movies.isEmpty)
    }
}
