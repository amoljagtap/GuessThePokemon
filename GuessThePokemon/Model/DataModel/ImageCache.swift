//
//  ImageCache.swift
//  GuessThePokemon
//
//  Created by Amol Jagtap on 22/12/2024.
//

import SwiftUI

/// Image Cache uses imageURL as an unique key for holding Image data.
final class ImageCache {
    
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL?) -> Image? {
        get {
            guard let url else { return nil }
            return ImageCache.cache[url]
        }
        set {
            guard let url else { return }
            ImageCache.cache[url] = newValue
        }
    }
    
    static func cache(images: [(Data, URL?)]) {
        images.forEach { (data, url) in
            if let url = url,
               let uiImage = UIImage(data: data) {
                ImageCache[url] = Image(uiImage: uiImage)
            }
        }
    }
}
