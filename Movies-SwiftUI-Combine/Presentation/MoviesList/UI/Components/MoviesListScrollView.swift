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
    let movies: [MovieViewItem]
    let onItemClick: (MovieViewItem) -> Void
    let onAppearAction: ((MovieViewItem) -> Void)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(movies, id: \.uuid) { movie in
                MovieCardView(movieItem: movie)
                    .onAppear {
                        onAppearAction(movie)
                    }
                    .onTapGesture {
                        onItemClick(movie)
                    }
            }
        }
    }
}
