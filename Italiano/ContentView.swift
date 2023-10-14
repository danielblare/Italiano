//
//  ContentView.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI
import SwiftData
import Observation

struct ContentView: View {
        
    var body: some View {
        TabView() {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            MapView()
                .tag(1)
                .tabItem { Label("Map", systemImage: "map") }
            MenuView()
                .tag(2)
                .tabItem { Label("Menu", systemImage: "list.clipboard") }
            Text("Account View")
                .tabItem { Label("Acount", systemImage: "person") }
            
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self)) + (try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self))) {
        ContentView()
            .environment(cacheManager)
    }
}
