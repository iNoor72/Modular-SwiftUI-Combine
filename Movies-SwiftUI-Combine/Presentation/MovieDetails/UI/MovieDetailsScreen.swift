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
                    viewModel.handle(.loadData)
                }
        case .loading:
            ProgressView()
        case .failure(_):
            RetryView {
                viewModel.handle(.loadData)
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
    }
    
    private var movieDetailsView: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                image(path: viewModel.movieDetails?.backdropPath ?? "")
                    .frame(width: UIScreen.width, height: UIScreen.height / 3)
                
                HStack(spacing: 4) {
                    image(path: viewModel.movieDetails?.posterPath ?? "")
                        .frame(width: 100, height: 200)
                    
                    LazyVStack {
                        Text("\(viewModel.movieDetails?.title ?? "") (\(viewModel.movieDetails?.releaseDate ?? ""))")
                    }
                }
                .padding(.horizontal, 16)
                
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.movieDetails?.overview ?? "")
                        .lineLimit(nil)
                    
                    Spacer()
                    
                    movieInfoView
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
    }
    
    private func image(path: String) -> some View {
        CacheAsyncImage(path: path, content: { phase in
            switch phase {
            case .empty:
                ProgressView()
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8.0)
                
                //Including error state
            default:
                Image(AppConstants.imagePlaceholderName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8.0)
            }
        })
    }
    
    private var movieInfoView: some View {
        LazyVStack(alignment: .leading, spacing: 4) {
            LazyHStack {
                Text("Homepage:")
                    .bold()
                    .foregroundStyle(.white)
                
                Text(viewModel.movieDetails?.homepage ?? "")
            }
            
            LazyHStack {
                Text("Languages:")
                    .bold()
                    .foregroundStyle(.white)
                
                Text(viewModel.movieDetails?.spokenLanguages?.map { $0.name }.joined(separator: ", ") ?? "")
                    .lineLimit(3)
            }
        }
    }
}

#Preview {
    MovieDetailsScreen(viewModel: MovieDetailsViewModel(movieId: 0, movieDetailsUseCase: MovieDetailsUseCaseMock()))
}
