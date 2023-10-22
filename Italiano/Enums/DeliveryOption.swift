//
//  DeliveryOption.swift
//  Italiano
//
//  Created by Daniel on 10/20/23.
//

import SwiftUI

enum DeliveryOption: String {
    case delivery
    case pickup
    
    var data: Any.Type {
        switch self {
        case .delivery: String.self
        case .pickup: Location.self
        }
    }
    
    var price: Double {
        switch self {
        case .delivery: 15
        case .pickup: 0
        }
    }
    
    var orderConfirmationTitle: Text {
        switch self {
        case .delivery: Text("Delivery to:")
        case .pickup: Text("Pickup from:")
        }
    }
}
