//
//  DeliveryInfo.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import Foundation

struct DeliveryInfo: Equatable, Hashable, Codable {
    let option: DeliveryOption
    let address: String
    
    static let dummy = DeliveryInfo(option: .delivery, address: "Test address")
}
