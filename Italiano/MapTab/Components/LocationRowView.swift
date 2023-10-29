//
//  LocationRowView.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import SwiftUI

/// Row view representing location on the map with description and ETA travel distance/time
struct LocationRowView: View {
    
    /// Manager for directions building
    let directionManager: DirectionManager
    
    /// Passed in location
    let location: Location
    
    /// Whether location is selected on the map
    let isSelected: Bool
    
    init(directionManager: DirectionManager = .shared, location: Location, isSelected: Bool = false) {
        self.directionManager = directionManager
        self.location = location
        self.isSelected = isSelected
    }
    
    /// ETA distance
    @State private var distance: String?
    /// ETA travel time
    @State private var travelTime: String?
    
    var body: some View {
        VStack {
            HStack {
                CachedImage(url: location.image)
                    .scaledToFill()
                    .frame(width: 80, height: 60)
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
                    .fill(Color.palette.lightGreen.gradient.opacity(0.3))
                    .strokeBorder(Color.palette.oliveGreen, lineWidth: 0.6)
            }
            
            if isSelected {
                Group {
                    Text(location.info)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(location.address)
                        .foregroundStyle(Color.palette.neutralDark)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)

                    Button {
                        directionManager.openInMaps(location)
                    } label: {
                        Text("Open in Maps")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }
                .font(.asset.menuItem)
                .padding(.horizontal)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.palette.oliveGreen, lineWidth: 0.5)
        }
        .task {
            guard let ETA = try? await DirectionManager.shared.getETA(to: location.coordinate) else { return }
            distance = ETA.distance.formattedDistance()
            travelTime = ETA.expectedTravelTime.formattedTravelTime()
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return NavigationStack {
        LocationRowView(directionManager: DirectionManager.shared, location: .dummy, isSelected: false)
            .padding()
    }
    .environment(dependencies)
}
