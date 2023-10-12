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
    @Environment(RouteManager.self) var routeManager: RouteManager

    @Query private var offers: [Offer]
    
    var body: some View {
        ScrollView {
            if !offers.isEmpty {
                OffersSection
            }
            
        }
        .navigationDestination(for: Route.self) { $0 }
    }
    
    var OffersSection: some View {
        VStack {
            Text("Special offers")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                let spacing: CGFloat = 15
                HStack(spacing: spacing) {
                    ForEach(offers) { offer in
                        NavigationLink(value: Route.offer(offer)) {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                OfferCellView(offer: offer)
                                    .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 3 : 6, spacing: spacing)
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
        .padding(.vertical)
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()

    return SwiftDataPreview(preview: PreviewContainer([Offer.self]),
                     items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self)) {
        NavigationStack {
            HomeView()
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
        }
        .environment(routeManager)
    }
}
