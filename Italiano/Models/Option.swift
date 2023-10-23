//
//  Option.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

struct Option: Codable, Identifiable, Equatable, Hashable {
    var id: String { name }
    let name: String
    var value: Bool
    
    init(name: String, value: Bool = false) {
        self.name = name
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decodeIfPresent(Bool.self, forKey: .value) ?? false
    }
    
    static let dummy = Option(name: "Cheese")
}
