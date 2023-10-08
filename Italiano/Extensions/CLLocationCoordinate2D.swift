//
//  CLLocationCoordinate2D.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Codable {
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Double(self.latitude), forKey: .latitude)
        try container.encode(Double(self.longitude), forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude: CLLocationDegrees = CLLocationDegrees(try container.decode(Double.self, forKey: .latitude))
        let longitude: CLLocationDegrees = CLLocationDegrees(try container.decode(Double.self, forKey: .longitude))
        self = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
