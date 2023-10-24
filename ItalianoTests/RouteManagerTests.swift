//
//  RouteManagerTests.swift
//  ItalianoTests
//
//  Created by Daniel on 10/8/23.
//

import XCTest
@testable import Italiano

final class RouteManagerTests: XCTestCase {

    private var routerManager: RouteManager!
    
    override func setUp() {
        routerManager = RouteManager()
    }

    override func tearDown() {
        routerManager = nil
    }
    
    func testRoutesIsEmptyOnInit() {
        XCTAssertEqual(routerManager.routes.count, 0, "Path should be empty")
    }
    
    func testPushingOneScreenHasOneRoute() {
        routerManager.push(to: .offer(.dummy))
        XCTAssertEqual(routerManager.routes.count, 1, "There should be 1 route in the path")
    }
    
    func testPushingTwoScreensHasTwoRoutes() {
        routerManager.push(to: .offer(.dummy))
        routerManager.push(to: .offer(.dummy))
        XCTAssertEqual(routerManager.routes.count, 2, "There should be 2 routes in the path")
    }
    
    func testResettingRoutesHasNoRoutes() {
        routerManager.push(to: .offer(.dummy))
        routerManager.push(to: .offer(.dummy))
        routerManager.reset()
        XCTAssertEqual(routerManager.routes.count, 0, "There should be 0 routes in the path")
    }
    
    func testGoingBackHasOneRoute() {
        routerManager.push(to: .offer(.dummy))
        routerManager.push(to: .offer(.dummy))
        routerManager.back()
        XCTAssertEqual(routerManager.routes.count, 1, "There should be 1  routes in the path")
    }
    
}
