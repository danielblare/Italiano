//
//  ItalianoApp.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI
import SwiftData
import Observation

// MARK: SwiftData Models
typealias Offer = SchemaV1.Offer
typealias Location = SchemaV1.Location
typealias MenuSection = SchemaV1.MenuSection
typealias MenuItem = SchemaV1.MenuItem
typealias Ingredient = SchemaV1.Ingredient
typealias Option = SchemaV1.Option

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
