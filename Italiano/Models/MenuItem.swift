//
//  MenuItem.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

struct MenuItem: Codable, Identifiable, Equatable, Hashable {
    var id: String { name }
    let name: String
    let info: String
    let price: Double
    let image: URL
    let ingredients: [Ingredient]
    var options: [Option]
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case image
        case info
        case ingredients
        case options
    }
    
    init(name: String, info: String, price: Double, image: URL, ingredients: [Ingredient], options: [Option] = []) {
        self.name = name
        self.info = info
        self.price = price
        self.image = image
        self.ingredients = ingredients
        self.options = options
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.info = try container.decode(String.self, forKey: .info)
        self.price = try container.decode(Double.self, forKey: .price)
        self.image = try container.decode(URL.self, forKey: .image)
        self.ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
        self.options = try container.decodeIfPresent([Option].self, forKey: .options) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(info, forKey: .info)
        try container.encode(price, forKey: .price)
        try container.encode(image, forKey: .image)
        try container.encode(ingredients, forKey: .ingredients)
        try container.encode(options, forKey: .options)
    }
    
    static let dummy = MenuItem(name: "Margherita", info: "30 cm, 8 pcs", price: 10.99, image: URL(string: "https://github.com/stuffeddanny/Italiano_files/blob/main/menu/pizza/items/margherita.png?raw=true")!, ingredients: [.dummy], options: [Option(name: "Cheese", value: true), Option(name: "Milk", value: true), Option(name: "Long test", value: true), Option(name: "Test", value: true)])
}
