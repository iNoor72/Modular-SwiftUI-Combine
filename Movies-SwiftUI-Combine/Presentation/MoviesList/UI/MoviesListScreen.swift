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
    }
    
    @ViewBuilder
    private var mainView: some View {
        switch viewModel.state {
        case .initial:
            Color.clear
                .onAppear {
                    viewModel.onAppear()
                }
        case .loading:
            ProgressView()
        case .failure(_):
            RetryView {
                viewModel.onAppear()
            }
        case .success:
            contentView
        }
    }
}


extension MoviesListScreen {
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: Constants.contentSpacing) {
            searchBar
            genresView
            moviesListView
        }
        .padding(.horizontal, Constants.contentSpacing)
    }
    
    private var searchBar: some View {
        SearchBarView(query: $viewModel.searchQuery)
            .padding(.horizontal, Constants.contentSpacing)
    }
    
    private var genresView: some View {
        GenresFilterView(genres: viewModel.genres, didSelectGenreAction: viewModel.didSelectGenreAction)
            .frame(height: 40)
    }
    
    private var moviesListView: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(viewModel.movies, id: \.id) {
                    MovieCardView(movieItem: $0)
                }
            }
        }
        .padding(.horizontal, Constants.contentSpacing)
    }
}

#Preview {
    MoviesListScreen(viewModel: MoviesListViewModel(genresUseCase: GenresUseCaseMock(), trendingMoviesUseCase: TrendingMoviesUseCaseMock()))
}
