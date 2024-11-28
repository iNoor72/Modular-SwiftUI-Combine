//
//  MovieDetailsFactoryTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 28/11/2024.
//

import XCTest
import SwiftUI
@testable import Movies_SwiftUI_Combine

final class MovieDetailsFactoryTests: XCTestCase {
    var sut: MovieDetailsFactoryProtocol!
    
    override func setUp() {
        sut = MovieDetailsFactory()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_makeFactory() {
        let viewController = sut.make(with: 1)
        
        XCTAssert(viewController is UIHostingController<MovieDetailsScreen>)
    }
}
