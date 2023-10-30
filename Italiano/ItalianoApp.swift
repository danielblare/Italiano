//
//  ItalianoApp.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI
import Observation
import SwiftData

// MARK: SwiftData Models
typealias CartItemSwiftData = SchemaV1.CartItemSwiftData
typealias Order = SchemaV1.Order
typealias Offer = SchemaV1.Offer
typealias Location = SchemaV1.Location
typealias MenuSection = SchemaV1.MenuSection
typealias FavoriteItem = SchemaV1.FavoriteItem

// MARK: Dependencies to inject
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
    
    private let modelContainer: ModelContainer
    
    init() {
        
        // Setting navigation text attributes color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.palette.oliveGreen)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.palette.oliveGreen)]
        
        /// Indicates whether user launched app first time
        @AppStorage("firstLaunch") var firstLaunch: Bool = true
        
        modelContainer = try! DataContainer.create(createDefaults: &firstLaunch)
        
        if ProcessInfo.processInfo.arguments.contains("-UITest_cleanCart"),
        let cartItems = try? modelContainer.mainContext.fetch(FetchDescriptor<CartItemSwiftData>()) {
            for item in cartItems {
                modelContainer.mainContext.delete(item)
            }
        }
        
        if ProcessInfo.processInfo.arguments.contains("-UITest_cleanFavorites"),
        let favorites = try? modelContainer.mainContext.fetch(FetchDescriptor<FavoriteItem>()) {
            for item in favorites {
                modelContainer.mainContext.delete(item)
            }
        }
        
        if ProcessInfo.processInfo.arguments.contains("-UITest_cleanOrders"),
        let orders = try? modelContainer.mainContext.fetch(FetchDescriptor<Order>()) {
            for item in orders {
                modelContainer.mainContext.delete(item)
            }
        }


    }
    
    /// Dependency injection
    @State private var dependencies: Dependencies = Dependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        // Inserting dependencies
        .environment(dependencies)
        // Creating model container
        .modelContainer(modelContainer)
    }
}
