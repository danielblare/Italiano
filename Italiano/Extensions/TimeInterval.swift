//
//  TimeInterval.swift
//  Italiano
//
//  Created by Daniel on 10/13/23.
//

import Foundation

extension TimeInterval {
    
    /// Formates time interval to format like 1 min, 1 hr 30 min, 1 day 10 hr
    func formattedTravelTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: self) ?? ""
    }
}
