//
//  CartItem.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

/// A protocol representing an item that can be added to a shopping cart
protocol CartItem {
    var item: MenuItem { get }
    var quantity: Int { get set }
    var totalPrice: Double { get }
}

/// Value type cart item model
struct CartItemModel: CartItem, Codable, Hashable, Equatable {
    /// Menu item
    let item: MenuItem
    /// Quantity of `item`
    var quantity: Int
    
    init(from model: CartItemSwiftData) {
        self.init(item: model.item, quantity: model.quantity)
    }
    
    init(item: MenuItem, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }
    
    /// Total price for quantity selected
    var totalPrice: Double {
        Double(quantity) * item.price
    }
    
    static var dummy: CartItemSwiftData {
        CartItemSwiftData(item: MenuItem.dummy, quantity: 2)
    }
}
