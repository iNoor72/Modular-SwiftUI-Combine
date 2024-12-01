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
            .foregroundStyle(.white)
    }
    
    private var textView: some View {
        VStack(alignment: .center, spacing: 8) {
            title
            subTitle
        }
        .padding(.horizontal, 16)
    }
}

extension RetryView {
    private var title: some View {
        Text("Failed to Load")
            .foregroundStyle(.white)
    }
    
    private var subTitle: some View {
        Text("An unexpected error has occurred. You can try again by refreshing this page")
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }
    
    private func browseButton(title: LocalizedStringKey, action : @escaping () -> Void) -> some View {
        Button() {
            action()
        } label: {
            HStack{
                Text(title)
                    .foregroundStyle(.white)
                
                Image(systemName: "arrow.circlepath")
            }
        }
    }
}
