//
//  ViewItemsCreationTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 01/12/2024.
//

import XCTest
@testable import Movies_SwiftUI_Combine

final class ViewItemsCreationTests: XCTestCase {
    func test_createMovieViewItem() {
        let item = MovieViewItem(id: "", uuid: UUID(), title: "", releaseDate: "", posterPath: nil)
        XCTAssertNotNil(item)
    }
    
    func test_createGenreViewItem() {
        let item = GenreViewItem(id: "", name: "")
        XCTAssertNotNil(item)
    }
    
    func test_createMovieDetailsViewItem() {
        let item = MovieDetailsViewItem(uuid: UUID(), id: "", title: "", budget: 1, revenue: 1, posterPath: "", releaseDate: "", backdropPath: "", overview: "", homepage: "", status: "", runtime: 0, genres: [])
        XCTAssertNotNil(item)
    }
    
    func test_createMoviesResponseViewItem() {
        let item = MoviesResponseViewItem(totalPages: 0, movies: [])
        XCTAssertNotNil(item)
    }
    
    func test_createSpokenLanguageViewItem() {
        let item = SpokenLanguageViewItem(name: "")
        XCTAssertNotNil(item)
    }
}
