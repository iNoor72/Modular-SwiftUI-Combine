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
        }
        .background(.black)
        .onChange(of: viewModel.searchQuery) { _ in
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
        case .loading:
            ProgressView()
        case .failure(_):
            RetryView {
                viewModel.handle(.loadData)
            }
        case .success:
            contentView(movies: viewModel.movies)
            
        case .searching:
            contentView(movies: viewModel.searchedMovies)
        }
    }
}


extension MoviesListScreen {
    @ViewBuilder
    private func contentView(movies: [MoviesResponseItem]) -> some View {
        SearchScrollView(
            query: $viewModel.searchQuery,
            showCancelButton: true,
            cancelAction: {
                viewModel.handle(.clearSearch)
            },
            scrollContent: {
                LazyVStack(spacing: Constants.contentSpacing) {
                    genresView
                    moviesListView(movies: viewModel.movies)
                    
                    if viewModel.hasMoreRows {
                        Text(AppStrings.fetchingMoreDataString)
                            .onAppear {
                                viewModel.handle(.loadMoreData)
                            }
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
        }
            .padding(.horizontal, Constants.contentSpacing)
    }
}
