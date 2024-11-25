//
//  MovieDetailsScreen.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct MovieDetailsScreen: View {
    @ObservedObject var viewModel: MovieDetailsViewModel
    
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

extension MovieDetailsScreen {
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 16) {
            movieDetailsView
        }
        .padding(.horizontal, 16)
    }
    
    private var movieDetailsView: some View {
        EmptyView()
    }
}

#Preview {
    MovieDetailsScreen(viewModel: MovieDetailsViewModel(movieId: 0, movieDetailsUseCase: MovieDetailsUseCaseMock()))
}
