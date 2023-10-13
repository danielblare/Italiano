//
//  LocationRowView.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import SwiftUI
import Observation

/// Row view representing location on the map with description and ETA travel distance/time
struct LocationRowView: View {
    
    /// Passed in location
    let location: Location
    
    /// Whether location is selected on the map
    let isSelected: Bool
    
    /// ETA distance
    @State private var distance: String?
    /// ETA travel time
    @State private var travelTime: String?
    
    var body: some View {
        HStack {
            CachedImage(url: location.image)
                .scaledToFill()
                .frame(width: 80, height: 60)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(location.name)
                    .lineLimit(2)
                
                Text(location.schedule)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)

            
            VStack(alignment: .trailing, spacing: 5) {
                Text(distance ?? "--")
                
                Label(travelTime ?? "--", systemImage: "car")
            }
        }
        .font(.asset.mainText)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.palette.lightGreen.gradient.opacity(isSelected ? 0.5 : 0.3))
                .strokeBorder(Color.palette.oliveGreen, lineWidth: 0.5, antialiased: true)
                .shadow(color: .palette.lightGreen.opacity(1), radius: 3, x: 1, y: 1)
        }
        .task {
            guard let ETA = try? await DirectionManager.shared.getETA(to: location.coordinate) else { return }
            distance = ETA.distance.formattedDistance()
            travelTime = ETA.expectedTravelTime.formattedTravelTime()
        }
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        NavigationStack {
            LocationRowView(location: .dummy, isSelected: false)
                .padding()
        }
    }
}
