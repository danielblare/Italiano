//
//  DeliveryInfo.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

/// Delivery information model
struct DeliveryInfo: Equatable, Hashable, Codable {
    /// Delivery option
    let option: DeliveryOption
    /// Delivery address
    let address: String
    
    static let dummy = DeliveryInfo(option: .delivery, address: "Test address")
}
