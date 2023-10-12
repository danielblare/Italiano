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
