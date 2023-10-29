//
//  JSONTests.swift
//  JSONTests
//
//  Created by Daniel on 10/5/23.
//

import XCTest
@testable import Italiano

final class JSONTests: XCTestCase {
    
    override func setUp() { }
    override class func tearDown() { }

    func testSuccessfulDecodingOffersList() {
        let fileName = "JSONOffersTests"
        var result: [Offer] = []
        
        
        XCTAssertNoThrow(result = try JSONDecoder.decode(from: fileName, type: [Offer].self), "Function shouldn't throw")
        XCTAssertEqual(result.count, 5, "Data was not decoded correctly")
    }

    func testFailingDecodingOffersList() {
        XCTAssertThrowsError(try JSONDecoder.decode(from: "WrongName", type: [Offer].self), "Decoding from wrong file doesn't fail")
        
        XCTAssertThrowsError(try JSONDecoder.decode(from: "JSONOffersTests", type: [Int].self), "Decoding wrong type doesn't fail")
    }
    
    func testSuccessfulDecodingLocationsList() {
        let fileName = "JSONLocationsTests"
        var result: [Location] = []
        
        
        XCTAssertNoThrow(result = try JSONDecoder.decode(from: fileName, type: [Location].self), "Function shouldn't throw")
        XCTAssertEqual(result.count, 10, "Data was not decoded correctly")
    }

    func testFailingDecodingLocationsList() {
        XCTAssertThrowsError(try JSONDecoder.decode(from: "WrongName", type: [Location].self), "Decoding from wrong file doesn't fail")
        
        XCTAssertThrowsError(try JSONDecoder.decode(from: "JSONLocationsTests", type: [Int].self), "Decoding wrong type doesn't fail")
    }
    
    func testSuccessfulDecodingMenu() {
        let fileName = "JSONMenuTests"
        var result: [MenuSection] = []
        
        
        XCTAssertNoThrow(result = try JSONDecoder.decode(from: fileName, type: [MenuSection].self), "Function shouldn't throw")
        XCTAssertEqual(result.count, 4, "Data was not decoded correctly")
    }

    func testFailingDecodingMenu() {
        XCTAssertThrowsError(try JSONDecoder.decode(from: "WrongName", type: [MenuSection].self), "Decoding from wrong file doesn't fail")
        
        XCTAssertThrowsError(try JSONDecoder.decode(from: "JSONMenuTests", type: [Int].self), "Decoding wrong type doesn't fail")
    }

}
