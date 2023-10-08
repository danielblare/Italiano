//
//  ContentView.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()

                Text("Map View")
                    .tabItem { Label("Map", systemImage: "map") }
                Text("Menu View")
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                Text("Account View")
                    .tabItem { Label("Acount", systemImage: "person") }
                
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SwiftDataPreview(preview: PreviewContainer([Offer.self]), items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self)) {
        ContentView()
    }
}
