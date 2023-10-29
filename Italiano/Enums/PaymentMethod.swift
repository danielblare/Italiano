//
//  PaymentMethod.swift
//  Italiano
//
//  Created by Daniel on 10/22/23.
//

import Foundation

/// Payment method
enum PaymentMethod: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case applePay
    case payPal
    case creditCard
    
    /// Text for the button that represents payment method
    var buttonText: String {
        switch self {
        case .applePay: "Pay with Apple Pay"
        case .payPal: "Pay with PayPal"
        case .creditCard: "Pay with credit/debit card"
        }
    }
}
