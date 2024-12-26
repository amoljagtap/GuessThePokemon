//
//  CachedAsyncImageView.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

struct CachedImageView: View {
    
    @State var imageUrl: URL?
    @Binding var showOriginalImage: Bool
    
    var body: some View {
#if DEBUG
        if CommandLine.arguments.contains("ui-testing") {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                .renderingMode(showOriginalImage ? .original : .template)
                .resizable()
                .scaledToFit()
        } else {
            content
        }
#else
        content
#endif
    }
    
    @ViewBuilder
    private var content: some View {
        if let image = ImageCache[imageUrl] {
            image
                .renderingMode(showOriginalImage ? .original : .template)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.0)
                .padding()
        }
    }
}
