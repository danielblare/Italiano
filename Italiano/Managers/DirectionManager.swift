//
//  DirectionManager.swift
//  Italiano
//
//  Created by Daniel on 10/13/23.
//

import Foundation
import MapKit

actor DirectionManager {
    
    /// Shared instance
    static let shared = DirectionManager()
    
    private init() {}
    
    /// Gets ETA to `coordinate`
    func getETA(to coordinate: CLLocationCoordinate2D) async throws -> MKDirections.ETAResponse {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(coordinate: coordinate)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        
        return try await directions.calculateETA()
    }
    
    /// Opens `location` in Apple Maps
    nonisolated func openInMaps(_ location: Location) {
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps()
    }
}
