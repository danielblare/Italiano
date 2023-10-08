//
//  MapView.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Query private var locations: [Location]
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2DMake(53.3498, -6.2603), latitudinalMeters: 20000, longitudinalMeters: 20000))
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Map")
                    .foregroundStyle(Color.palette.oliveGreen)
                    .font(.asset.heading2)
                
                MapView
                    .frame(height: 250)
                
            }
            .padding()
        }
    }
    
    var MapView: some View {
        Map(initialPosition: cameraPosition) {
            ForEach(locations) { location in
                Marker(location.name, systemImage: "fork.knife", coordinate: location.coordinate)
                    .tint(.tomatoRed)
            }
            
//            Annotation("My Location", coordinate: userLocation) {
//                Circle().fill(.blue)
//                    .frame(width: 100, height: 10)
//            }
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
