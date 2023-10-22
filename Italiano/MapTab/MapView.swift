//
//  MapView.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI
import MapKit

/// Map tab view
struct MapView: View {
    
    @State private var viewModel: MapViewModel = MapViewModel()
    
    private let locations: [Location] = (try? JSONDecoder.decode(from: "Locations", type: [Location].self)) ?? []
    
    /// Location selected by user on the map
    @State private var selectedLocation: Location?
    
    /// Default map camera position
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2DMake(53.3498, -6.2603), latitudinalMeters: 20000, longitudinalMeters: 20000))
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {                    
                    MapView
                        .id("map")
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
                            LocationRowView(directionManager: .shared, location: location, isSelected: selectedLocation == location)
                                .padding(.vertical, 4)
                                .onTapGesture {
                                    if selectedLocation == location {
                                        selectedLocation = nil
                                    } else {
                                        selectedLocation = location
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
            .animation(.interactiveSpring, value: selectedLocation)
            .onChange(of: selectedLocation) { oldValue, newValue in
                proxy.scrollTo("map", anchor: .center)
            }
        }
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
        locations.sorted { loc1, loc2 in
            if let selectedLocation {
                return loc1 == selectedLocation
            } else
            if let userLocation = viewModel.locationManager.location {
                return userLocation.distance(from: CLLocation(from: loc1.coordinate)) < userLocation.distance(from: CLLocation(from: loc2.coordinate))
            } else {
                return true
            }
        }
    }
    
}


#Preview {
    @State var dependencies = Dependencies()
    @Bindable var routeManager = dependencies.routeManager

    return NavigationStack(path: $routeManager.routes) {
        MapView()
            .navigationDestination(for: Route.self) { $0 }
    }
    .environment(dependencies)
}
