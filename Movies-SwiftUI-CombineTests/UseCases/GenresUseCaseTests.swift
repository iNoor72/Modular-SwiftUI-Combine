//
//  GenresUseCaseTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import Combine
@testable import Movies_SwiftUI_Combine

final class GenresUseCaseTests: XCTestCase {
    var sut: GenresUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = GenresUseCaseMock()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_execute() {
        let expectation = XCTestExpectation(description: "executeGenresUseCase")
        sut.execute()
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
