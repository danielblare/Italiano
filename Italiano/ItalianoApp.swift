//
//  ItalianoApp.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI
import Observation

// MARK: SwiftData Models
typealias CartItem = SchemaV1.CartItem
typealias Order = SchemaV1.Order
typealias Offer = SchemaV1.Offer
typealias Location = SchemaV1.Location
typealias MenuSection = SchemaV1.MenuSection
typealias FavoriteItem = SchemaV1.FavoriteItem

@Observable
final class Dependencies {
    let cacheManager: CacheManager
    let routeManager: RouteManager
    let cartManager: CartManager
    
    init() {
        self.cacheManager = CacheManager()
        self.routeManager = RouteManager()
        self.cartManager = CartManager()
        
    }
}

@main
struct ItalianoApp: App {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.palette.oliveGreen)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.palette.oliveGreen)]
    }
    
    /// Indicates whether user launched app first time
    @AppStorage("firstLaunch") private var firstLaunch: Bool = true
    
    @State private var dependencies: Dependencies = Dependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(dependencies)
        .modelContainer(try! DataContainer.create(createDefaults: &firstLaunch))
    }
}
