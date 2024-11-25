//
//  MoviesListScreen.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct MoviesListScreen: View {
    @ObservedObject var viewModel: MoviesListViewModel
    
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
        VStack(spacing: 16) {
            searchBar
            filtersView
            moviesListView
        }
        .padding(.horizontal, 16)
    }
    
    private var searchBar: some View {
        EmptyView()
    }
    
    private var filtersView: some View {
        EmptyView()
    }
    
    private var moviesListView: some View {
        EmptyView()
    }
}

#Preview {
    MoviesListScreen(viewModel: MoviesListViewModel(genresUseCase: GenresUseCaseMock(), trendingMoviesUseCase: TrendingMoviesUseCaseMock()))
}
