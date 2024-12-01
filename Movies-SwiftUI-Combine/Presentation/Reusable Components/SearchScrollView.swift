//
//  SearchScrollView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//

import SwiftUI

struct SearchScrollView<ScrollContent: View, OnSearchContent: View> : View {
    // MARK: - Inputs
    @Binding var query: String
    var showCancelButton: Bool = false
    var cancelAction: (() -> ())? = nil
    @ViewBuilder var scrollContent: ScrollContent
    @ViewBuilder var onSearchContent: OnSearchContent
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                searchBar
                if showCancelButton {
                    cancelButton
                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            
            scrollView
        }
    }
}

// MARK: - Components
extension SearchScrollView {
    private var searchBar: some View {
        SearchBarView(query: $query)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            cancelAction?()
        }
        .foregroundStyle(.white)
    }
    
    private var scrollView: some View {
        ScrollView {
            if query.isEmpty {
                scrollContent
            } else {
                onSearchContent
            }
        }
        .scrollIndicators(.hidden)
    }
}
