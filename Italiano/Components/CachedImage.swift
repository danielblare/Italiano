//
//  CachedImage.swift
//  Italiano
//
//  Created by Daniel on 10/9/23.
//

import SwiftUI

/// Tries to fetch image from cache. If it's not there just downloads image and caches it for future
struct CachedImage: View {
    
    @Environment(CacheManager.self) private var manager: CacheManager
    
    let url: URL
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
            let key = url.relativePath
            
            if let savedImage = manager.getFrom(manager.imagesCache, forKey: key) {
                self.image = savedImage
            } else {
                if let data = try? await URLSession.shared.data(from: url).0,
                   let image = UIImage(data: data) {
                    self.image = image
                    manager.addTo(manager.imagesCache, forKey: key, value: image)
                }
            }
        }
    }
}

#Preview {
    @State var manager = CacheManager()
    
    return CachedImage(url: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/offers/taste_of_tuscany.png?raw=true")!)
        .frame(width: 300, height: 300)
        .environment(manager)
}
