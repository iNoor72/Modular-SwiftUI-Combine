//
//  GenresFilterView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct GenresFilterView: View {
    var genres: [GenreItem]
    var didSelectGenreAction: ((GenreItem) -> ())?
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(genres, id: \.self) { genre in
                    GenresFilterItem(genre: genre, didSelectGenreAction: didSelectGenreAction)
                }
            }
        }
    }
}
