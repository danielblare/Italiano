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
    var showOrderComplete: Bool = false

    func addToCart(item: MenuItem, cart: [CartItemSwiftData], context: ModelContext) {
        if let index = cart.firstIndex(where: { $0.item == item }) {
            cart[index].quantity += 1
        } else {
            let newItem = CartItemSwiftData(item: item)
            context.insert(newItem)
        }
        addedToCartItem = item
    }
    
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
