//
//  File.swift
//  
//
//  Created by Noor El-Din Walid on 16/09/2024.
//


import XCTest
import Combine
@testable import NetworkLayer

final class RealNetworkManagerTests: XCTestCase {
    var sut: NetworkServiceProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }
    
    func test_request() {
        let endpoint = MockEndpoint.mock
        let expectation = XCTestExpectation(description: "Request")
        
        do {
            try sut
                .fetch(endpoint: endpoint, expectedType: MockModel.self)
                .sink(receiveCompletion: { completion in
                    //Code should go here
                    if case .failure = completion {
                        expectation.fulfill()
                    }
                }, receiveValue: { model in
                    //Should not go here
                    XCTFail()
                })
                .store(in: &cancellables)
        } catch {
            XCTFail()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
