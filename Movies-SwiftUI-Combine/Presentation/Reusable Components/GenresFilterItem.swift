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
        Text(genre.name ?? "")
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.yellow, lineWidth: 1)
            )
            .onTapGesture {
                didSelectGenreAction?(genre)
            }
            .padding(4)
            .background {
                if true {
                    
                } else {
                    Color.black
                }
            }
            .presentationCornerRadius(16)
    }
}
