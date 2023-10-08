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
    
    @Bindable var routeManager: RouteManager
        
    var body: some View {
        NavigationStack(path: $routeManager.routes) {
            TabView {
//                HomeView(routeManager: routeManager)

                MapView()
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
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        ContentView(routeManager: routeManager)
    }
}
