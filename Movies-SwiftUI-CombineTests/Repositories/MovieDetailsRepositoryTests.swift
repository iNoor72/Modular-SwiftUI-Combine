//
//  MovieDetailsRepositoryTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import Combine
import NetworkLayer
import CachingLayer
@testable import Movies_SwiftUI_Combine

final class MovieDetailsRepositoryTests: XCTestCase {
    var sut: MovieDetailsRepositoryProtocol!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        sut = MovieDetailsRepository(network: MockNetworkManager.shared, cache: MoviesCacheManagerMock.shared)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
    }
    
    func test_fetchMovieDetails() {
        let expectation = XCTestExpectation(description: "executeFetchMovieDetailsFromMovieDetailsRepository")
        sut.fetchMovieDetails(with: 1)
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
