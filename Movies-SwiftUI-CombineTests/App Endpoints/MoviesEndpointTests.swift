//
//  MoviesEndpointTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import XCTest
@testable import Movies_SwiftUI_Combine

final class MoviesEndpointTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_trendingEndpointConstruction() {
        let endpoint = MoviesEndpoint.trending(page: 1, genreIDs: [])
        guard let request = try? endpoint.asURLRequest() else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(request.url?.absoluteString.contains("/discover/movie"))
        if let doesContainPath = request.url?.absoluteString.contains("/discover/movie") {
            XCTAssertTrue(doesContainPath)
        }
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
        XCTAssertNotNil(request.allHTTPHeaderFields)
    }
}
