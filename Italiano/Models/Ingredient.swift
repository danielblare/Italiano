//
//  Ingredient.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

/// Ingredient model
struct Ingredient: Codable, Identifiable, Equatable, Hashable {
    var id: String { name }
    
    /// Name of ingredient
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    static let dummy = Ingredient(name: "Cheese")
}
