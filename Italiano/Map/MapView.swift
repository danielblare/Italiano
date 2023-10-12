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

struct MapView: View {
    @State private var viewModel: MapViewModel = MapViewModel()
    @Query private var locations: [Location]
    
    @State var selectedLocation: Location?
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2DMake(53.3498, -6.2603), latitudinalMeters: 2000, longitudinalMeters: 2000))
    
    @State private var showMore: Bool = false
    
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
                
                let sortedLocations = viewModel.sortedByDistance(locations)
                ForEach(showMore ? sortedLocations : Array(sortedLocations.prefix(3))) {
                    LocationRowView(location: $0)
                        .environment(viewModel)
                        .padding(.vertical, 4)
                }
                
                ShowMoreButton
                    .padding()
                
            }
            .padding()
        }
        .animation(.snappy, value: showMore)
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
    }
    
    var ShowMoreButton: some View {
        Button {
            showMore.toggle()
        } label: {
            HStack {
                Text(showMore ? "Show Less" : "Show More")
                
                Image(systemName: showMore ? "chevron.up" : "chevron.down")
            }
        }
    }
    
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
