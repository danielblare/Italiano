//
//  ItalianoUITests.swift
//  ItalianoUITests
//
//  Created by Daniel on 10/5/23.
//

import XCTest

final class ItalianoUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments += ["-UITest_cleanCart", "-UITest_cleanFavorites", "-UITest_cleanOrders"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
    }
    
    func testAddingItemToCart() {
        let tabBarsQuery = app.tabBars
        let menuTab = tabBarsQuery.buttons["Menu"]
        menuTab.tap()
        
        let firstSection = app.buttons["MenuSection 0"]
        firstSection.tap()
        
        let firstItem = app.buttons["MenuItem 0"]
        firstItem.staticTexts.firstMatch.tap()
        
        let pizzaToAdd = app.staticTexts["name"].label
        
        let addToCart = app.buttons["AddToCart"]
        addToCart.tap()
        
        let viewCart = app.buttons["ViewCart"]
        viewCart.tap()
        
        XCTAssertTrue(app.buttons[pizzaToAdd].exists)
    }
    
    func testChangingItemQuantity() {
        testAddingItemToCart()
        
        let firstItem = app.buttons["CartItem 0"]
        
        firstItem.tap()
        
        let qty = app.staticTexts["Qty"]
        let incrementButton = app.buttons["Increment"]
        let decrementButton = app.buttons["Decrement"]
        XCTAssertFalse(decrementButton.isEnabled)
        incrementButton.tap()
        XCTAssertEqual(2, Int(qty.label.leaveOnlyNumbers()))
        decrementButton.tap()
        XCTAssertEqual(1, Int(qty.label.leaveOnlyNumbers()))

        incrementButton.tap()
        incrementButton.tap()
        XCTAssertEqual(3, Int(qty.label.leaveOnlyNumbers()))

        let backButton = app.buttons["Cart"]
        backButton.tap()
        
        XCTAssertEqual(3, Int(qty.label.leaveOnlyNumbers()))
        
    }
    
    func testAddFavoriteItem() {
        let tabBarsQuery = app.tabBars
        let menuTab = tabBarsQuery.buttons["Menu"]
        menuTab.tap()
        
        let firstSection = app.buttons["MenuSection 0"]
        firstSection.tap()
        
        let firstItem = app.buttons["MenuItem 0"]
        firstItem.staticTexts.firstMatch.tap()
        
        let pizzaToAdd = app.staticTexts["name"].label
        
        let makeFavorite = app.buttons["Favorite"]
        makeFavorite.tap()
        
        let backButton = app.navigationBars.buttons.firstMatch
        backButton.tap()
        backButton.tap()

        let homeTab = tabBarsQuery.buttons["Home"]
        homeTab.tap()

        let favoriteItem = app.buttons["FavoriteItem 0"]
        favoriteItem.tap()
        
        let favoriteName = app.staticTexts["name"].label
        
        XCTAssertEqual(pizzaToAdd, favoriteName)
    }
    
    func testPlacingOrderWithAddress() {
        testAddingItemToCart()
        
        let number = "1234567812345678"
        let expiration = "1123"
        let cvv = "123"
        let address = "Test Address"
        
        let deliveryButton = app.staticTexts["DeliveryOption.delivery"]
        deliveryButton.tap()
        
        let addressField = app.textFields["Address"]
        addressField.tap()
        addressField.typeText(address)
                
        let proceedButton = app.buttons["Proceed"]
        proceedButton.tap()
        
        let creditCardMethod = app.buttons["Method creditCard"]
        creditCardMethod.tap()
        
        let numberField = app.textFields["number"]
        numberField.tap()
        clearField(numberField)
        numberField.typeText(number)

        let expirationField = app.textFields["expiration"]
        expirationField.tap()
        clearField(expirationField)
        expirationField.typeText(expiration)

        let cvvField = app.textFields["cvv"]
        cvvField.tap()
        clearField(cvvField)
        cvvField.typeText(cvv)
        
        cvvField.typeText(XCUIKeyboardKey.return.rawValue)
        proceedButton.tap()
        
        XCTAssertEqual(address, app.staticTexts["Address"].label)
        
        let confirmButton = app.buttons["Confirm"]
        confirmButton.tap()
        
        let mainScreenButton = app.buttons["MainScreen"]
        mainScreenButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Home"].isSelected)
        
        let recentOrder = app.buttons["RecentOrder 0"]
        recentOrder.tap()
        
        XCTAssertEqual(address, app.staticTexts["Address"].label)

    }
    
    func testPlacingOrderWithPickup() {
        testAddingItemToCart()
        
        let number = "1234567812345678"
        let expiration = "1123"
        let cvv = "123"
        
        let pickupButton = app.staticTexts["DeliveryOption.pickup"]
        pickupButton.tap()
        
        let pickupSelector = app.images["PickupSelector"]
        pickupSelector.tap()
        
        let location = app.buttons["Location 0"]
        location.tap()
                
        let proceedButton = app.buttons["Proceed"]
        proceedButton.tap()
        
        let creditCardMethod = app.buttons["Method creditCard"]
        creditCardMethod.tap()
        
        let numberField = app.textFields["number"]
        numberField.tap()
        clearField(numberField)
        numberField.typeText(number)

        let expirationField = app.textFields["expiration"]
        expirationField.tap()
        clearField(expirationField)
        expirationField.typeText(expiration)

        let cvvField = app.textFields["cvv"]
        cvvField.tap()
        clearField(cvvField)
        cvvField.typeText(cvv)
        
        cvvField.typeText(XCUIKeyboardKey.return.rawValue)
        proceedButton.tap()
                
        let confirmButton = app.buttons["Confirm"]
        confirmButton.tap()
        
        let mainScreenButton = app.buttons["MainScreen"]
        mainScreenButton.tap()

        XCTAssertTrue(app.tabBars.buttons["Home"].isSelected)
        
        let recentOrder = app.buttons["RecentOrder 0"]
        recentOrder.tap()
        
    }

    private func clearField(_ field: XCUIElement) {
        field.tap(withNumberOfTaps: 2, numberOfTouches: 2)
        field.typeText(XCUIKeyboardKey.delete.rawValue)
    }
}

fileprivate extension String {
    func leaveOnlyNumbers() -> String {
        self.filter({ "0123456789".contains($0) })
    }
}
