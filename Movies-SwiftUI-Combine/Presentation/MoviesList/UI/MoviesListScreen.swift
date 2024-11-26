//
//  MoviesListScreen.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct MoviesListScreen: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
    private enum Constants {
        static let contentSpacing: CGFloat = 16
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            mainView
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .background(.black)
        .onChange(of: viewModel.debounceValue) { _ in
            viewModel.handle(.search)
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        switch viewModel.state {
        case .initial:
            Color.clear
                .onAppear {
                    viewModel.handle(.loadData)
                }
        case .failure:
            RetryView {
                viewModel.handle(.loadData)
            }
        case .success, .searching:
            contentView
        }
    }
}


extension MoviesListScreen {
    @ViewBuilder
    private var contentView: some View {
        SearchScrollView(
            query: $viewModel.searchQuery,
            showCancelButton: true,
            cancelAction: {
                viewModel.handle(.clearSearch)
            },
            scrollContent: {
                LazyVStack(spacing: Constants.contentSpacing) {
                    genresView
                    if viewModel.selectedGenres.isEmpty {
                        moviesListView(movies: viewModel.movies)
                    } else {
                        moviesListView(movies: viewModel.filteredMovies)
                    }
                }
                .padding(.horizontal, Constants.contentSpacing)
            }, onSearchContent: {
                LazyVStack(spacing: Constants.contentSpacing) {
                    genresView
                    moviesListView(movies: viewModel.searchedMovies)
                }
                .padding(.horizontal, Constants.contentSpacing)
            })
    }
    
    private var genresView: some View {
        GenresFilterView(genres: viewModel.genres) { genre in
            viewModel.handle(.didSelectGenre(genre))
        }
            .frame(height: 40)
    }
    
    private func moviesListView(movies: [MoviesResponseItem]) -> some View {
        MoviesListScrollView(movies: movies) { movie in
            viewModel.handle(.navigateToDetails(movie))
        } onAppearAction: { movie in
            viewModel.validatePagination(with: movie)
        }
            .padding(.horizontal, Constants.contentSpacing)
    }
}
