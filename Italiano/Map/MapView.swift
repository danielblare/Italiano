//
//  MapView.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI
import MapKit
import SwiftData
import Observation

/// Map tab view
struct MapView: View {
    @State private var viewModel: MapViewModel = MapViewModel()
    @Query private var locations: [Location]
     
    /// Location selected by user on the map
    @State var selectedLocation: Location?
    
    /// Default map camera position
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2DMake(53.3498, -6.2603), latitudinalMeters: 20000, longitudinalMeters: 20000))
        
    var body: some View {
        ScrollView {
            VStack {
                Text("Map")
                    .foregroundStyle(Color.palette.oliveGreen)
                    .font(.asset.heading2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                MapView
                    .frame(height: 250)
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(Color.palette.lightGreen)
                    .padding(.vertical)
                
                Text("Closest to you:")
                    .foregroundStyle(Color.palette.oliveGreen)
                    .font(.asset.heading2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                let sortedLocations = sortedByDistance(locations)
                if sortedLocations.isEmpty {
                    ContentUnavailableView("No Locations", systemImage: "mappin.slash")
                        .padding()
                } else {
                    ForEach(sortedLocations) { location in
                        LocationRowView(location: location, isSelected: selectedLocation == location)
                            .padding(.vertical, 4)
                            .onTapGesture {
                                DirectionManager.shared.openInMaps(location)
                            }
                    }
                }
            }
            .padding()
        }
        .animation(.interactiveSpring, value: selectedLocation)
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
    }
    
    /// Map View
    var MapView: some View {
        Map(initialPosition: cameraPosition, selection: $selectedLocation) {
            UserAnnotation()
            
            ForEach(locations) { location in
                Marker(location.name, systemImage: "fork.knife", coordinate: location.coordinate)
                    .tint(.oliveGreen)
                    .tag(location)
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
    }
    
    /// Sorts locations by distance
    private func sortedByDistance(_ locations: [Location]) -> [Location] {
        guard let userLocation = viewModel.locationManager.location else { return locations }
        return locations.sorted {
            if let selectedLocation {
                return $0 == selectedLocation
            } else {
                return userLocation.distance(from: CLLocation(from: $0.coordinate)) < userLocation.distance(from: CLLocation(from: $1.coordinate))
            }
        }
    }

}


#Preview {
    @State var routeManager: RouteManager = RouteManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        NavigationStack {
            MapView()
        }
    }
}
