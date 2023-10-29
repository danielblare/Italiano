//
//  CLLocation.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import MapKit

extension CLLocation {
    convenience init(from coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLLocationDistance {
    
    /// Formats distance to format like 1 m, 100 m, 1.2 km, 100 km etc
    func formattedDistance() -> String {
        let meters = Measurement(value: self, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.positiveSuffix = " "
        
        if meters.value > 1000 {
            let kilometers = meters.converted(to: .kilometers)
            return formatter.string(from: kilometers)
        } else {
            return formatter.string(from: meters)
        }
    }
}

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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
