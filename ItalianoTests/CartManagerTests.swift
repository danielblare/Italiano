//
//  CartManagerTests.swift
//  ItalianoTests
//
//  Created by Daniel on 10/24/23.
//

import XCTest
import SwiftData
@testable import Italiano

final class CartManagerTests: XCTestCase {

    private var cartManager: CartManager!
    private var container: ModelContainer!

    override func setUp() {
        cartManager = CartManager()
        
        let schema = Schema(versionedSchema: SchemaV1.self)
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        self.container = container
    }

    override func tearDown() {
        cartManager = nil
        container.deleteAllData()
        container = nil
    }
    
    func testSameItemAdding() {
        let context: ModelContext = .init(container)

        // Creating Cart
        let menuItem = MenuItem.dummy
        let cart: [CartItemSwiftData] = [CartItemSwiftData(item: menuItem)]
        
        // Adding item
        cartManager.addToCart(item: menuItem, cart: cart, context: context)
        
        // Checking for an item
        XCTAssertEqual(cartManager.addedToCartItem, menuItem)
        XCTAssertEqual(cart.first?.quantity, 2)
    }
    
    func testDifferentItemAdding() throws {
        let context: ModelContext = .init(container)

        // Creating Cart
        let menuItem1 = MenuItem.dummy
        let menuItem2 = MenuItem(name: "Name2", info: "info2", price: 1, image: MenuItem.dummy.image, ingredients: [])
        let cart: [CartItemSwiftData] = [CartItemSwiftData(item: menuItem1)]
        cart.forEach { context.insert($0) }
        
        // Adding item
        cartManager.addToCart(item: menuItem2, cart: cart, context: context)
        
        let updatedCart = try context.fetch(FetchDescriptor<CartItemSwiftData>())

        // Checking for an item
        XCTAssertEqual(cartManager.addedToCartItem, menuItem2)
        XCTAssertEqual(updatedCart.count, 2)
    }


    func testOrderPlacement() throws {
        let context: ModelContext = .init(container)
        
        let cartItem = CartItemSwiftData.dummy
        
        // Adding item to the cart
        context.insert(cartItem)
        
        // Placing order
        try cartManager.placeOrder(deliveryInfo: .dummy, context: context)
        
        // Checking if cart is empty
        let updatedCart = try context.fetch(FetchDescriptor<CartItemSwiftData>())
        XCTAssertTrue(updatedCart.isEmpty)
        
        // Checking if there is an order
        let orders = try context.fetch(FetchDescriptor<Order>())
        XCTAssertEqual(orders.count, 1)
        
        // Checking if screen appeared
        XCTAssertTrue(cartManager.showOrderComplete)
    }
}
