//
//  DataContainer.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import Foundation
import SwiftData


actor DataContainer {
    
    /// Creates container 
    @MainActor
    static func create(createDefaults: inout Bool) throws -> ModelContainer {
        let schema = Schema(versionedSchema: SchemaV1.self)
        let configuration = ModelConfiguration()
        let container = try ModelContainer(for: schema, configurations: configuration)
        if createDefaults {
            if let offers = try? JSONDecoder.decode(from: "Offers", type: [Offer].self) {
                offers.forEach { offer in
                    container.mainContext.insert(offer)
                }
            }
            
            if let locations = try? JSONDecoder.decode(from: "Locations", type: [Location].self) {
                locations.forEach { location in
                    container.mainContext.insert(location)
                }
            }
            
            createDefaults = false
        }
        
        return container
    }
}
