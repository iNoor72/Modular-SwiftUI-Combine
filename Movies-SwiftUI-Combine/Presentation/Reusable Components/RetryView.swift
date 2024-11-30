//
//  RetryView.swift
//  Movies-SwiftUI-Combine
//
//  Created by Noor El-Din Walid on 26/11/2024.
//


import SwiftUI

struct RetryView: View {
    var action: () -> Void
    var dismissAction: (() -> ())?
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Spacer()
            imageView
            textView
            browseButton(title: "Refresh", action: action)
            Spacer()
        }
    }
}

extension RetryView {
    private var imageView: some View {
        Image(systemName: "arrow.circlepath")
            .resizable()
            .frame(maxWidth: 200, maxHeight: 200)
    }
    
    private var textView: some View {
        VStack(alignment: .center, spacing: 8) {
            title
            subTitle
                .padding(.horizontal, 32)
        }
    }
}

extension RetryView {
    private var title: some View {
        Text("Failed to Load")
    }
    
    private var subTitle: some View {
        Text("An unexpected error has occurred. You can try again by refreshing this page")
            .multilineTextAlignment(.center)
    }
    
    private func browseButton(title: LocalizedStringKey, action : @escaping () -> Void) -> some View {
        Button() {
            action()
        } label: {
            HStack{
                Text(title)
                Image(systemName: "arrow.circlepath")
            }
        }
    }
}
