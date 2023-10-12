//
//  MapViewModel.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import Foundation
import MapKit
import Observation

@Observable
final class MapViewModel {
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    init() {
        
    }
    
    func getETA(to coordinate: CLLocationCoordinate2D) async throws -> MKDirections.ETAResponse {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        
        return try await directions.calculateETA()
    }
    
    func formattedDistance(value: CLLocationDistance) -> String {
        let meters = Measurement(value: value, unit: UnitLength.meters)
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
    
    func formattedTravelTime(value: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .day]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: value) ?? ""
    }
    
    func sortedByDistance(_ locations: [Location]) -> [Location] {
        guard let userLocation = locationManager.location else { return locations }
        return locations.sorted {
            userLocation.distance(from: CLLocation(from: $0.coordinate)) < userLocation.distance(from: CLLocation(from: $1.coordinate))
        }
    }
    
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
