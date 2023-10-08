//
//  JSONTests.swift
//  JSONTests
//
//  Created by Daniel on 10/5/23.
//

import XCTest
@testable import Italiano

final class JSONTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    func test_successfull_decoding_offers_list() {
        let fileName = "JSONOffersTests"
        var result: [Offer] = []
        
        
        XCTAssertNoThrow(result = try JSONDecoder.decode(from: fileName, type: [Offer].self), "Function shouldn't throw")
        XCTAssertEqual(result.count, 5, "Data was not decoded correctly")
    }

    func test_failing_decoding_offers_list() {
        XCTAssertThrowsError(try JSONDecoder.decode(from: "WrongName", type: [Offer].self), "Decoding from wrong file doesn't fail")
        
        XCTAssertThrowsError(try JSONDecoder.decode(from: "JSONOffersTests", type: [Int].self), "Decoding wrong type doesn't fail")
    }

}