//
//  MovieItemView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct MovieCardView: View {
    var movieItem: MovieViewItem
    
    var body: some View {
        HStack {
            VStack {
                CacheAsyncImage(path: movieItem.posterPath ?? "", content: { phase in
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
                .frame(height: 250)
                
                Text(movieItem.title)
                    .bold()
                    .foregroundStyle(.white)
                
                Text(movieItem.releaseDate)
                    .foregroundStyle(.white)
            }
        }
    }
}

