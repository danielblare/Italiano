//
//  Double.swift
//  Italiano
//
//  Created by Daniel on 10/15/23.
//

import Foundation

extension Double {
    
    /// Formats value as a price looking like `$10.99`
    func formatPrice() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        currencyFormatter.minimumFractionDigits = 0
        currencyFormatter.maximumFractionDigits = 2

        return currencyFormatter.string(from: self as NSNumber) ?? ""
    }
}
