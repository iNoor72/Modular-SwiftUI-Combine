//
//  MovieDetailsViewModelTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
@testable import Movies_SwiftUI_Combine

final class MovieDetailsViewModelTests: XCTestCase {
    var sut: MovieDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailsViewModel(movieId: 1, movieDetailsUseCase: MovieDetailsUseCaseMock(), networkMonitor: MockNetworkMonitor())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_loadData() {
        sut.handle(.loadData)
        
        XCTAssertNil(sut.movieDetails)
    }
}
