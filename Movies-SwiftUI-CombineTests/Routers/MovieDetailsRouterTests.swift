//
//  MovieDetailsRouterTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import Foundation
@testable import Movies_SwiftUI_Combine
import XCTest
import SwiftUI

final class MovieDetailsRouterTests: XCTestCase {
    var sut: MovieDetailsRouterProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailsRouter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_navigateToDetails() {
        sut.navigate(to: .newScreen)
        
        XCTAssertNil(sut.viewController)
    }
}
