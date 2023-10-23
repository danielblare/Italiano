//
//  CartItem.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

struct CartItemModel: Codable {
    let item: MenuItem
    var quantity: Int
    
    init(from model: CartItem) {
        self.init(item: model.item, quantity: model.quantity)
    }
    
    init(item: MenuItem, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }
    
    var totalPrice: Double {
        Double(quantity) * item.price
    }
    
    static var dummy: CartItem {
        CartItem(item: MenuItem.dummy, quantity: 2)
    }
}
