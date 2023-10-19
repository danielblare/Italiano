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
    @Environment(RouteManager.self) private var routeManager

    // Temp
    @Query private var cartItems: [CartItem]
    
    private let offers: [Offer]
    
    init(offers: [Offer]) {
        self.offers = offers
    }
    
    var body: some View {
        ScrollView {
            if !offers.isEmpty {
                OffersSection
            }
            Button("Cart") {
                routeManager.push(to: .cart)
            }
        }
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
    @State var cacheManager: CacheManager = CacheManager()
    @State var routeManager: RouteManager = RouteManager()
    @Bindable var man = routeManager
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        NavigationStack(path: $man.routes) {
            HomeView(offers: try! JSONDecoder.decode(from: "Offers", type: [Offer].self))
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(cacheManager)
        .environment(routeManager)
    }
}
