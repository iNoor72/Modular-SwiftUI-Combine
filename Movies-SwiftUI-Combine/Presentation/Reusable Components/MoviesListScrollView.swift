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
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(movies, id: \.id) {
                    MovieCardView(movieItem: $0)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
