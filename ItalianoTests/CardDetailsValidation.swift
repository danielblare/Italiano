//
//  CardDetailsValidation.swift
//  ItalianoTests
//
//  Created by Daniel on 10/24/23.
//

import XCTest
@testable import Italiano

final class CardDetailsValidation: XCTestCase {

    func testNumberFieldValidation() {
        // Empty
        let emptyNumber = CardDetails(number: "")
        
        XCTAssertFalse(CardDetails.Field.number.validate(input: emptyNumber))

        // Short
        let shortNumber = CardDetails(number: "123891011121")
        
        XCTAssertFalse(CardDetails.Field.number.validate(input: shortNumber))

        // Long
        let longNumber = CardDetails(number: "12389101112231414141")
        
        XCTAssertFalse(CardDetails.Field.number.validate(input: longNumber))

        // Correct
        let correctNumber = CardDetails(number: "1111222233334444")
        
        XCTAssertTrue(CardDetails.Field.number.validate(input: correctNumber))

    }
    
    func testExpirationFieldValidation() {
        // Empty
        let emptyExpiration = CardDetails(expiration: "")
        
        XCTAssertFalse(CardDetails.Field.expiration.validate(input: emptyExpiration))
        
        // Short
        let shortExpiration = CardDetails(expiration: "123")
        
        XCTAssertFalse(CardDetails.Field.expiration.validate(input: shortExpiration))

        // Long
        let longExpiration = CardDetails(expiration: "13145")
        
        XCTAssertFalse(CardDetails.Field.expiration.validate(input: longExpiration))

        // Correct
        let correctExpiration = CardDetails(expiration: "1224")
        
        XCTAssertTrue(CardDetails.Field.expiration.validate(input: correctExpiration))

    }
    
    func testCvvFieldValidation() {
        // Empty
        let emptyCvv = CardDetails(cvv: "")
        
        XCTAssertFalse(CardDetails.Field.cvv.validate(input: emptyCvv))
        
        // Short
        let shortCvv = CardDetails(cvv: "12")
        
        XCTAssertFalse(CardDetails.Field.cvv.validate(input: shortCvv))

        // Long
        let longCvv = CardDetails(cvv: "1314")
        
        XCTAssertFalse(CardDetails.Field.cvv.validate(input: longCvv))

        // Correct
        let correctCvv = CardDetails(cvv: "124")
        
        XCTAssertTrue(CardDetails.Field.cvv.validate(input: correctCvv))
    }
}
