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
    
    @Environment(RouteManager.self) var routeManager: RouteManager
    
    var body: some View {
        @Bindable var routeManager = routeManager
        NavigationStack(path: $routeManager.routes) {
            TabView(selection: .constant(1)) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)
                MapView()
                    .tag(1)
                    .tabItem { Label("Map", systemImage: "map") }
                Text("Menu View")
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                Text("Account View")
                    .tabItem { Label("Acount", systemImage: "person") }
                
            }
            .navigationTitle("Italiano")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()
    @State var cacheManager: CacheManager = CacheManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        ContentView()
            .environment(routeManager)
            .environment(cacheManager)
    }
}
