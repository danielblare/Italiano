//
//  ItalianoApp.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI

// MARK: SwiftData Models
typealias CartItem = SchemaV1.CartItem

@main
struct ItalianoApp: App {
    
    /// Indicates whether user launched app first time
    @AppStorage("firstLaunch") private var firstLaunch: Bool = true
    
    @State private var cacheManager: CacheManager = CacheManager()
    @State private var routeManager: RouteManager = RouteManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(cacheManager)
        .environment(routeManager)
        .modelContainer(try! DataContainer.create(createDefaults: &firstLaunch))
    }
}
