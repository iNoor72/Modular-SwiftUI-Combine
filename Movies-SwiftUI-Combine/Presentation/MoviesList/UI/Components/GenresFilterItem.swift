//
//  GenresFilterItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct GenresFilterItem: View {
    var genre: GenreViewItem
    var didSelectGenreAction: ((GenreViewItem) -> ())?
    
    var body: some View {
        Text(genre.name)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background {
                if genre.isSelected {
                    Color.yellow
                        .cornerRadius(16)
                } else {
                    Color.black
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.yellow, lineWidth: 1)
                        )
                }
            }
            .padding(8)
            .cornerRadius(16)
            .onTapGesture {
                didSelectGenreAction?(genre)
            }
    }
}
