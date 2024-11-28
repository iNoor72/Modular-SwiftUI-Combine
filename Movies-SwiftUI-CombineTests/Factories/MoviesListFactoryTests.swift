//
//  MoviesListFactoryTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import SwiftUI
@testable import Movies_SwiftUI_Combine

final class MoviesListFactoryTests: XCTestCase {
    var sut: MoviesListFactoryProtocol!
    
    override func setUp() {
        sut = MoviesListFactory()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_makeFactory() {
        let viewController = sut.make()
        
        XCTAssert(viewController is UIHostingController<MoviesListScreen>)
        XCTAssertEqual(viewController.navigationItem.title, "Movies")
    }
}
