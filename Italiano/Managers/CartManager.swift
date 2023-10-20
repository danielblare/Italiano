//
//  CartManager.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import Foundation
import Observation
import SwiftData

@Observable final class CartManager {
    
    var addedToCartItem: MenuItem?
    
    func addToCart(item: MenuItem, cart: [CartItem], context: ModelContext) {
        if let index = cart.firstIndex(where: { $0.item == item }) {
            cart[index].quantity += 1
        } else {
            let newItem = CartItem(item: item)
            context.insert(newItem)
        }
        addedToCartItem = item
    }
}