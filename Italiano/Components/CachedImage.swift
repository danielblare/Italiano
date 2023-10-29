//
//  CachedImage.swift
//  Italiano
//
//  Created by Daniel on 10/9/23.
//

import SwiftUI

/// Image view which fetches data from cache if present or downloads it and saves to the cache if not
struct CachedImage: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies

    /// URL for the image
    let url: URL
    
    /// Main Image returned by the view
    @State private var image: UIImage?
    
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            
            Image(uiImage: image ?? UIImage())
                .resizable()
            
            if image == nil {
                ProgressView()
            }
        }
        .task {
            let manager = dependencies.cacheManager
            let cache = manager.imagesCache
            
            /// Generates key under which image will be cached
            let key = url.relativePath
            
            if let savedImage = manager.getFrom(cache, forKey: key) { // Tries to get image from cache
                self.image = savedImage
            } else if let data = try? await URLSession.shared.data(from: url).0, // Tries to get data from the url
                      let image = UIImage(data: data) {
                self.image = image
                // Adding image to the cache
                manager.addTo(cache, forKey: key, value: image)
            }
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return CachedImage(url: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!)
        .frame(width: 300, height: 300)
        .environment(dependencies)
}
