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
        .ignoresSafeArea()
        .background(.black)
        .alert(isPresented: $viewModel.isNetworkConnectionLost) {
            Alert(title: Text("Error"), message: Text(AppStrings.noNetworkAlertMessage), primaryButton: .default(Text("Retry"), action: {
                viewModel.handle(.retryAction)
            }), secondaryButton: .cancel())
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
                .tint(.white)
        case .failure(_):
            RetryView {
                viewModel.handle(.loadData)
            }
        case .success, .offline:
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
                image(path: viewModel.movieDetails.backdropPath)
                    .frame(width: UIScreen.width, height: UIScreen.height / 3)
                
                HStack(spacing: 4) {
                    image(path: viewModel.movieDetails.posterPath)
                        .frame(width: 100, height: 200)
                    
                    LazyVStack(alignment: .leading, spacing: 8) {
                        Text("\(viewModel.movieDetails.title) (\(viewModel.movieDetails.releaseDate))")
                            .foregroundStyle(.white)
                            .bold()
                            .font(.title3)
                        
                        Text(viewModel.movieDetails.genres.compactMap { $0.name }.joined(separator: ", "))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 16)
                
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.movieDetails.overview)
                        .foregroundStyle(.white)
                        .lineLimit(nil)
                    
                    Spacer()
                    
                    movieInfoView
                }
                .padding(.horizontal, 2)
            }
        }
        .ignoresSafeArea()
        .scrollIndicators(.hidden)
        .padding(.bottom, 80)
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
                
                //Including error state
            default:
                Image(AppConstants.imagePlaceholderName)
                    .resizable()
                    .scaledToFit()
            }
        })
    }
    
    private var movieInfoView: some View {
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Homepage:")
                        .foregroundStyle(.white)
                        .bold()

                    let homepage = viewModel.movieDetails.homepage
                    Text(LocalizedStringKey(homepage.isEmpty ? "N/A" : homepage))
                }
                
                HStack {
                    Text("Languages:")
                        .foregroundStyle(.white)
                        .bold()
                    
                    let spokenLanguages = viewModel.movieDetails.spokenLanguages?.compactMap { $0.name }.joined(separator: ", ") ?? "N/A"
                    Text(spokenLanguages.isEmpty ? "N/A" : spokenLanguages)
                        .foregroundStyle(.white)
                }
            }
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                HStack {
                    Text("Status:")
                        .foregroundStyle(.white)
                        .bold()
                    
                    let status = viewModel.movieDetails.status
                    Text(status.isEmpty ? "N/A" : status)
                        .foregroundStyle(.white)
                        .lineLimit(0)
                }
                
                HStack {
                    Text("Runtime:")
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("\(viewModel.movieDetails.runtime) minutes")
                        .foregroundStyle(.white)
                        .lineLimit(0)
                }
                
                HStack {
                    Text("Budget:")
                        .bold()
                        .foregroundStyle(.white)
                    
                    Text("\(viewModel.movieDetails.budget) $")
                        .foregroundStyle(.white)
                        .lineLimit(0)
                }
                
                HStack {
                    Text("Revenue:")
                        .foregroundStyle(.white)
                        .bold()
                    
                    Text("\(viewModel.movieDetails.revenue) $")
                        .foregroundStyle(.white)
                        .lineLimit(nil)
                }
            }
        }
    }
}

#Preview {
    MovieDetailsScreen(viewModel: MovieDetailsViewModel(movieId: 0, movieDetailsUseCase: MovieDetailsUseCaseMock(), networkMonitor: NetworkMonitor.shared))
}
