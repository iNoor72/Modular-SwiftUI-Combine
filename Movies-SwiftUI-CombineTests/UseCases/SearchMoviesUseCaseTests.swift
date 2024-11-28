//
//  SearchMoviesUseCaseTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import Combine
@testable import Movies_SwiftUI_Combine

final class SearchMoviesUseCaseTests: XCTestCase {
    var sut: SearchMoviesUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = SearchMoviesUseCaseMock()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_execute() {
        let expectation = XCTestExpectation(description: "executeSearchMoviesUseCase")
        sut.execute(page: 1, query: "")
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
