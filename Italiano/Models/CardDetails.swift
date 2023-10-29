//
//  CardDetails.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

/// Card details model
struct CardDetails: RawRepresentable {
    
    /// Fields for card details entering
    enum Field: CaseIterable {
        case number, expiration, cvv
        
        /// Validates field in `input`
        func validate(input: CardDetails) -> Bool {
            switch self {
            case .number: input.number.filter({ "0123456789".contains($0) }).count == 16
            case .expiration: input.expiration.filter({ "0123456789".contains($0) }).count == 4
            case .cvv: input.cvv.filter({ "0123456789".contains($0) }).count == 3
            }
        }
    }
    
    /// Card number
    var number: String
    
    /// Card expiration date
    var expiration: String
    
    /// Card CVV code
    var cvv: String
    
    /// Validates `field`
    func validate(field: Field? = nil) -> Bool {
        if let field {
            return field.validate(input: self)
        } else {
            return Field.allCases.allSatisfy({ $0.validate(input: self) })
        }
    }
    
    init(number: String = "", expiration: String = "", cvv: String = "") {
        self.number = number
        self.expiration = expiration
        self.cvv = cvv
    }
    
    init?(rawValue: String) {
        let components = rawValue.components(separatedBy: "|")
        guard components.count == 3 else { return nil }
        
        self.number = components[0]
        self.expiration = components[1]
        self.cvv = components[2]
    }
    
    var rawValue: String {
        "\(number)|\(expiration)|\(cvv)"
    }
}
