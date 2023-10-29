//
//  DeliveryOption.swift
//  Italiano
//
//  Created by Daniel on 10/20/23.
//

import SwiftUI

/// Delivery option
enum DeliveryOption: String, Codable {
    case delivery
    case pickup
    
    /// Price for delivery option
    var price: Double {
        switch self {
        case .delivery: 15
        case .pickup: 0
        }
    }
    
    /// Title for order confirmation screen
    var orderConfirmationTitle: Text {
        switch self {
        case .delivery: Text("Delivery to:")
        case .pickup: Text("Pickup from:")
        }
    }
}
