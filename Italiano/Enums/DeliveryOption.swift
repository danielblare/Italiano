//
//  DeliveryOption.swift
//  Italiano
//
//  Created by Daniel on 10/20/23.
//

import SwiftUI

enum DeliveryOption: String, Codable {
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
        case .delivery: return 15
        case .pickup: return 0
        }
    }
}
