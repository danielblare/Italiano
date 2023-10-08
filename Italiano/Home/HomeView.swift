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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Special offers")
                    .foregroundStyle(Color.palette.oliveGreen)
                    .font(.asset.heading2)
                    .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(offers) { offer in
                            NavigationLink(value: offer) {
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
            .navigationDestination(for: Offer.self) { OfferView(offer: $0) }
        }
    }
}

#Preview {
    SwiftDataPreview(preview: PreviewContainer([Offer.self]),
                     items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self)) {
        HomeView()
    }
}
