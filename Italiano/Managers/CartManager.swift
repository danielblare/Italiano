//
//  CartManager.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import Foundation
import Observation
import SwiftData

/// Cart manager
@Observable final class CartManager {
    
    /// Item added to the cart, used to display "Item successfully added screen"
    var addedToCartItem: MenuItem?
    
    /// Shows "Order complete" screen
    var showOrderComplete: Bool = false

    /// Adding item to the cart or makes quantity +1 if item was already added
    func addToCart(item: MenuItem, cart: [CartItemSwiftData], context: ModelContext) {
        if let index = cart.firstIndex(where: { $0.item == item }) {
            cart[index].quantity += 1
        } else {
            let newItem = CartItemSwiftData(item: item)
            context.insert(newItem)
        }
        addedToCartItem = item
    }
    
    /// Placing order with `deliveryInfo` provided
    func placeOrder(deliveryInfo: DeliveryInfo, context: ModelContext) throws {
        let cart = try context.fetch(FetchDescriptor<CartItemSwiftData>())
        let order = Order(items: cart, deliveryInfo: deliveryInfo)
        context.insert(order)
        cart.forEach { item in
            context.delete(item)
        }
        
        showOrderComplete = true
    }
}
