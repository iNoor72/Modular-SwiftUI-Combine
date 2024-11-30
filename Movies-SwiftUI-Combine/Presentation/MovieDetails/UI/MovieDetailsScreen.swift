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
        .alert(isPresented: $viewModel.isNetworkConnectionLost) {
            Alert(title: Text("Error"), message: Text(AppStrings.noNetworkAlertMessage), primaryButton: .default(Text("Retry"), action: {
                viewModel.handle(.retryAction)
            }), secondaryButton: .cancel())
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? ""), primaryButton: .default(Text("Retry"), action: {
                viewModel.handle(.resetError)
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
        case .failure(_):
            RetryView {
                viewModel.handle(.loadData)
            }
        case .success:
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
                image(path: viewModel.movieDetails?.backdropPath ?? "")
                image(path: viewModel.movieDetails.backdropPath)
                    .frame(width: UIScreen.width, height: UIScreen.height / 3)
                
                HStack(spacing: 4) {
                    image(path: viewModel.movieDetails?.posterPath ?? "")
                    image(path: viewModel.movieDetails.posterPath)
                        .frame(width: 100, height: 200)
                    
                    LazyVStack {
                        Text("\(viewModel.movieDetails?.title ?? "") (\(viewModel.movieDetails?.releaseDate ?? ""))")
                    LazyVStack(alignment: .leading, spacing: 8) {
                        Text("\(viewModel.movieDetails.title) (\(viewModel.movieDetails.releaseDate))")
                            .bold()
                            .font(.title3)
                        
                        Text(viewModel.movieDetails.genres.map { $0.name }.joined(separator: ", "))
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 16)
                
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text(viewModel.movieDetails?.overview ?? "")
                    Text(viewModel.movieDetails.overview)
                        .lineLimit(nil)
                    
                    Spacer()
                    
                    movieInfoView
                }
                .padding(.horizontal, 16)
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
        let columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Homepage:")
                        .bold()

                    let homepage = viewModel.movieDetails.homepage
                    Text(LocalizedStringKey(homepage.isEmpty ? "N/A" : homepage))
                }
                
                Text(viewModel.movieDetails?.homepage ?? "")
                HStack {
                    Text("Languages:")
                        .bold()
                    
                    let spokenLanguages = viewModel.movieDetails.spokenLanguages?.map { $0.name }.joined(separator: ", ") ?? "N/A"
                    Text(spokenLanguages.isEmpty ? "N/A" : spokenLanguages)
                }
            }
            
            LazyHStack {
                Text("Languages:")
                    .bold()
                    .foregroundStyle(.white)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                HStack {
                    Text("Status:")
                        .bold()
                    
                    let status = viewModel.movieDetails.status
                    Text(status.isEmpty ? "N/A" : status)
                        .lineLimit(0)
                }
                
                Text(viewModel.movieDetails?.spokenLanguages?.map { $0.name }.joined(separator: ", ") ?? "")
                    .lineLimit(3)
                HStack {
                    Text("Runtime:")
                        .bold()
                    
                    Text("\(viewModel.movieDetails.runtime) minutes")
                        .lineLimit(0)
                }
                
                HStack {
                    Text("Budget:")
                        .bold()
                    
                    Text("\(viewModel.movieDetails.budget) $")
                        .lineLimit(0)
                }
                
                HStack {
                    Text("Revenue:")
                        .bold()
                    
                    Text("\(viewModel.movieDetails.revenue) $")
                        .lineLimit(nil)
                }
            }
        }
    }
}

#Preview {
    MovieDetailsScreen(viewModel: MovieDetailsViewModel(movieId: 0, movieDetailsUseCase: MovieDetailsUseCaseMock(), networkMonitor: NetworkMonitor.shared))
}
