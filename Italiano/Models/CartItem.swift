//
//  CartItem.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

protocol CartItem {
    var item: MenuItem { get }
    var quantity: Int { get set }
    var totalPrice: Double { get }
}

struct CartItemModel: CartItem, Codable, Hashable, Equatable {
    let item: MenuItem
    var quantity: Int
    
    init(from model: CartItemSwiftData) {
        self.init(item: model.item, quantity: model.quantity)
    }
    
    init(item: MenuItem, quantity: Int = 1) {
        self.item = item
        self.quantity = quantity
    }
    
    var totalPrice: Double {
        Double(quantity) * item.price
    }
    
    static var dummy: CartItemSwiftData {
        CartItemSwiftData(item: MenuItem.dummy, quantity: 2)
    }
}
