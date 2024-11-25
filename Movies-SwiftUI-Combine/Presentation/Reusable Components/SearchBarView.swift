//
//  SearchBarView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 25/11/2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var query: String
    
    private enum Constants {
        static let searchBarIcon = "magnifyingglass"
        static let contentSpacing: CGFloat = 16
    }
    
    var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            searchIcon
            searchTextField
        }
    }
    
    private var searchIcon: some View {
        Image(systemName: Constants.searchBarIcon)
    }
    
    private var searchTextField: some View {
        TextField("Search ...", text: $query)
    }
}
