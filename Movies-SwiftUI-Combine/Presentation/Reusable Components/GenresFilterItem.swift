//
//  GenresFilterItem.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct GenresFilterItem: View {
    var genre: Genre
    var didSelectGenreAction: (() -> ())?
    
    var body: some View {
        Text(genre.title)
            .padding()
            .frame(height: 40)
            .onTapGesture {
                didSelectGenreAction?()
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
