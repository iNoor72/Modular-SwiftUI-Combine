//
//  GenresFilterItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct GenresFilterItem: View {
    var genre: GenreItem
    var didSelectGenreAction: ((GenreItem) -> ())?
    
    var body: some View {
        Text(genre.name)
            .padding()
            .frame(height: 40)
            .onTapGesture {
                didSelectGenreAction?(genre)
            }
            .padding(.horizontal, 10)
            .background {
                if genre.isSelected {
                    
                } else {
                    Color.black
                }
            }
            .presentationCornerRadius(16)
    }
}
