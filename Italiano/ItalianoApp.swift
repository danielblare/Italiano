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

@main
struct ItalianoApp: App {
    
    /// Indicates whether user launched app first time
    @AppStorage("firstLaunch") private var firstLaunch: Bool = true
    
    @State private var routeManager: RouteManager = RouteManager()

    var body: some Scene {
        WindowGroup {
            ContentView(routeManager: routeManager)
        }
        .modelContainer(try! DataContainer.create(createDefaults: &firstLaunch))
    }
}
