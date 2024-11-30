//
//  MoviesListRouterTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 29/11/2024.
//

import Foundation
@testable import Movies_SwiftUI_Combine
import XCTest
import SwiftUI

final class MoviesListRouterTests: XCTestCase {
    var sut: MoviesListRouterProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MoviesListRouter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_navigateToDetails() {
        sut.navigate(to: .movieDetails(MovieViewItem(id: 1, uuid: UUID(), title: "", releaseDate: "", posterPath: nil)))
        
        XCTAssertNil(sut.viewController)
    }
}
