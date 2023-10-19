//
//  ContentView.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI

struct ContentView: View {
    
    enum Tab {
        case home, map, menu, account
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .map: return "Map"
            case .menu: return "Menu"
            case .account: return "Account"
            }
        }
    }
    
    @Environment(RouteManager.self) private var routeManager
    @Environment(CartManager.self) private var cartManager
    
    @State private var tabSelection: Tab = .home

    var body: some View {
        @Bindable var routeManager = routeManager
        @Bindable var cartManager = cartManager
        NavigationStack(path: $routeManager.routes) {
            TabView(selection: $tabSelection) {
                HomeView(offers: (try? JSONDecoder.decode(from: "Offers", type: [Offer].self)) ?? [])
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(Tab.home)
                MapView(locations: (try? JSONDecoder.decode(from: "Locations", type: [Location].self)) ?? [])
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(Tab.map)
                MenuView(sections: (try? JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) ?? [])
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                    .tag(Tab.menu)
                Text("Account View")
                    .tabItem { Label("Account", systemImage: "person") }
                    .tag(Tab.account)
                
            }
            .navigationDestination(for: Route.self) { $0 }
            .navigationTitle(tabSelection.title)
            .toolbar(.hidden, for: .navigationBar)
        }
        .fullScreenCover(item: $cartManager.addedToCartItem) {
            ItemAddedView(item: $0)
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()
    @State var cartManager: CartManager = CartManager()
    @State var routeManager: RouteManager = RouteManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        ContentView()
            .environment(cacheManager)
            .environment(routeManager)
            .environment(cartManager)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    routeManager.push(to: .cart)
                }
            }
    }
}
