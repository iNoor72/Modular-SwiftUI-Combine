//
//  MoviesListScrollView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct MoviesListScrollView: View {
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let movies: [MoviesResponseItem]
    let onItemClick: (MoviesResponseItem) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(movies, id: \.id) { movie in
                    MovieCardView(movieItem: movie)
                        .onTapGesture {
                            onItemClick(movie)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
