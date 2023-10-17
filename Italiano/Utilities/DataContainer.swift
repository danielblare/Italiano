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
            
            createDefaults = false
        }
        
        return container
    }
}
