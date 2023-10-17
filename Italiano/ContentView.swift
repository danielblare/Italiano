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
    
    @Environment(RouteManager.self) private var routeManager
        
    var body: some View {
        @Bindable var routeManager = routeManager
        NavigationStack(path: $routeManager.routes) {
            TabView(selection: .constant(2)) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(0)
                MapView()
                    .tag(1)
                    .tabItem { Label("Map", systemImage: "map") }
                MenuView(sections: (try? JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) ?? [])
                    .tag(2)
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                Text("Account View")
                    .tabItem { Label("Acount", systemImage: "person") }
                
            }
            .navigationDestination(for: Route.self) { $0 }
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()
    @State var routeManager: RouteManager = RouteManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        ContentView()
            .environment(cacheManager)
            .environment(routeManager)
    }
}
