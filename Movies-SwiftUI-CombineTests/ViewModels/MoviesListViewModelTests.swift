//
//  MoviesListViewModelTests.swift
//  Movies-SwiftUI-CombineTests
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import XCTest
@testable import Movies_SwiftUI_Combine

final class MoviesListViewModelTests: XCTestCase {
    var sut: MoviesListViewModel!
    
    override func setUp() {
        let dep = MoviesListDependencies(router: MoviesListRouter(), genresUseCase: GenresUseCaseMock(), trendingMoviesUseCase: TrendingMoviesUseCaseMock(), searchUseCase: SearchMoviesUseCaseMock())
        sut = MoviesListViewModel(dependencies: dep)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_fetchMovies() {
        sut.handle(.loadData)
        
        XCTAssertEqual(sut.movies.count, 0)
        XCTAssertEqual(sut.genres.count, 0)
        XCTAssertFalse(sut.hasMoreRows)
    }
    
    func test_fetchMoreMovies() {
        sut.handle(.loadMoreData)
        
        XCTAssertEqual(sut.movies.count, 0)
    }
    
    func test_search() {
        sut.handle(.search)
        
        XCTAssertEqual(sut.searchedMovies.count, 0)
    }
    
    func test_clearSearch() {
        sut.handle(.clearSearch)
        
        XCTAssertEqual(sut.searchedMovies.count, 0)
        XCTAssertEqual(sut.selectedGenres.count, 0)
        XCTAssertEqual(sut.searchQuery, "")
        XCTAssertEqual(sut.debounceValue, "")
    }
}
