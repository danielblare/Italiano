//
//  HomeView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @Query private var offers: [Offer]
    
    @Bindable var routeManager: RouteManager

    var body: some View {
        ScrollView {
            if !offers.isEmpty {
                OffersSection
            }
            
        }
        .navigationDestination(for: Route.self) { $0 }
    }
    
    var OffersSection: some View {
        VStack(alignment: .leading) {
            Text("Special offers")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(offers) { offer in
                        NavigationLink(value: Route.offer(offer)) {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                OfferCellView(offer: offer)
                                    .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 3 : 6, spacing: 15)
                            } else {
                                OfferCellView(offer: offer)
                                    .frame(width: 100)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 20, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()

    return SwiftDataPreview(preview: PreviewContainer([Offer.self]),
                     items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self)) {
        NavigationStack {
            HomeView(routeManager: routeManager)
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
