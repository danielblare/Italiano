//
//  LocationRowView.swift
//  Italiano
//
//  Created by Daniel on 10/12/23.
//

import SwiftUI
import Observation

struct LocationRowView: View {
    @Environment(MapViewModel.self) private var viewModel
    let location: Location
    
    @State private var distance: String?
    @State private var travelTime: String?
    
    var body: some View {
        HStack {
            Image("test")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 60)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(location.name)
                    .lineLimit(2)
                
                Text("Closed - Opens 3pm")
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
                .strokeBorder(Color.palette.oliveGreen, lineWidth: 0.5, antialiased: true)
                .shadow(color: .palette.lightGreen.opacity(1), radius: 3, x: 1, y: 1)
        }
        .task {
            guard let ETA = try? await viewModel.getETA(to: location.coordinate) else { return }
            distance = viewModel.formattedDistance(value: ETA.distance)
            travelTime = viewModel.formattedTravelTime(value: ETA.expectedTravelTime)
        }
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()
    @State var viewModel: MapViewModel = MapViewModel()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self))) {
        NavigationStack {
            LocationRowView(location: .dummy)
                .environment(viewModel)
                .padding()
        }
    }
}
