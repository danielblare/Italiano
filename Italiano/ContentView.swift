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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Italiano")
                        .font(.asset.heading2)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.palette.tomatoRed)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.cart) {
                        Image(systemName: "basket")
                    }
                }
            }
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
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self)) + (try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) + [Order.dummy] + [FavoriteItem.dummy]) {
        ContentView()
            .environment(dependencies)
        //            .onAppear {
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //                    dependencies.routeManager.push(to: .cart)
        //                }
        //            }
    }
}
