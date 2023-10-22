//
//  ContentView.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    
    /// Tab view tabs
    enum Tab {
        case home, map, menu
        
        var title: String {
            switch self {
            case .home: "Home"
            case .map: "Map"
            case .menu: "Menu"
            }
        }
    }
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    
    /// Currently selected tab
    @State private var tabSelection: Tab = .home

    var body: some View {
        @Bindable var routeManager = dependencies.routeManager
        @Bindable var cartManager = dependencies.cartManager
        NavigationStack(path: $routeManager.routes) {
            TabView(selection: $tabSelection) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(Tab.home)
                MapView()
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(Tab.map)
                MenuView()
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                    .tag(Tab.menu)
            }
            .navigationDestination(for: Route.self) { $0 }
            .navigationTitle(tabSelection.title)
            .toolbar(.hidden, for: .navigationBar)
        }
        .fullScreenCover(item: $cartManager.addedToCartItem) {
            ItemAddedView(item: $0)
        }
        .fullScreenCover(isPresented: $cartManager.showOrderComplete) {
            OrderCompleteView()
        }
        .sensoryFeedback(.success, trigger: cartManager.addedToCartItem) { _, newValue in
            newValue != nil
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        ContentView()
            .environment(dependencies)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dependencies.routeManager.push(to: .cart)
                }
            }
    }
}
