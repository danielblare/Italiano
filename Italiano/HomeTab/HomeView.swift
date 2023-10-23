//
//  HomeView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @Query private let offers: [Offer]
    @Query(sort: \Order.date, order: .reverse) private let orders: [Order]

    var body: some View {
        ScrollView {
            OffersSection
            
            RecentOrdersSection
        }
    }
    
    private var RecentOrdersSection: some View {
        VStack {
            Text("Recent offers")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if orders.isEmpty {
                Text("There are no recent orders")
                    .font(.asset.extra)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView(.horizontal) {
                    let spacing: CGFloat = 15
                    HStack(spacing: spacing) {
                        ForEach(orders) { order in
                            NavigationLink(value: Route.cart) {
                                if UIDevice.current.userInterfaceIdiom == .phone {
                                    RecentOrderCellView(order: order)
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 3 : 6, spacing: spacing)
                                } else {
                                    RecentOrderCellView(order: order)
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
        .padding(.vertical)
    }
    
    private var OffersSection: some View {
        VStack {
            Text("Special offers")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if offers.isEmpty {
                Text("There are no special offers at the moment")
                    .font(.asset.extra)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
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
        }
        .padding(.vertical)
    }
}

#Preview {
    @State var dependencies = Dependencies()
    @Bindable var routeManager = dependencies.routeManager
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + [Order.dummy, Order(items: [.dummy], deliveryInfo: .dummy, date: .distantFuture)]) {
        NavigationStack(path: $routeManager.routes) {
            HomeView()
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
    }
}
