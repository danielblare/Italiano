//
//  MapViewModel.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import Foundation
import MapKit

@Observable
final class MapViewModel {
    let locationManager: CLLocationManager = CLLocationManager()
        
    /// Checked user's location authorization status
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        default: break
        }
    }
}
