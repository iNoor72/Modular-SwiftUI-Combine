//
//  NetworkManagerTests.swift
//  
//
//  Created by Noor El-Din Walid on 16/09/2024.
//

import XCTest
import Combine
@testable import NetworkLayer

final class MockNetworkManagerTests: XCTestCase {
    var sut: NetworkServiceProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = MockNetworkManager.shared
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    func test_endpoint_construction() {
        let endpoint = MockEndpoint.mock
        guard let request = try? endpoint.asURLRequest() else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.url?.path(), "/test")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNotNil(request.allHTTPHeaderFields?.isEmpty)
        XCTAssertNil(request.httpBody)
    }
    
    func test_request() {
        let endpoint = MockEndpoint.mock
        let expectation = XCTestExpectation(description: "Request")
        
        do {
            try sut
                .fetch(endpoint: endpoint, expectedType: MockModel.self)
                .sink(receiveCompletion: { completion in
                    return
                }, receiveValue: { model in
                    XCTAssertEqual(model.id, 1)
                    XCTAssertEqual(model.body, "Test")
                    XCTAssertEqual(model.name, "Noor")
                    expectation.fulfill()
                })
                .store(in: &cancellables)
        } catch {
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
