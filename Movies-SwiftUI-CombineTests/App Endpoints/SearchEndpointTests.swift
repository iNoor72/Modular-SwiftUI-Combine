//
//  SearchEndpointTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import XCTest
@testable import Movies_SwiftUI_Combine

final class SearchEndpointTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_trendingEndpointConstruction() {
        let endpoint = SearchEndpoint.search(page: 1, query: "")
        guard let request = try? endpoint.asURLRequest() else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(request.url?.absoluteString.contains("/search/movie"))
        if let doesContainPath = request.url?.absoluteString.contains("/search/movie") {
            XCTAssertTrue(doesContainPath)
        }
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
        XCTAssertNotNil(request.allHTTPHeaderFields)
    }
}
