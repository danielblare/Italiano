//
//  RouteManager.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI
import Observation

/// Route value for navigation path
enum Route: Hashable {
    case offer(_ offer: Offer)
    case menuSection(_ section: MenuSection)
    case menuItem(_ item: MenuItem)
    case cart, cartItemOverview(_ item: CartItemSwiftData)
    case cardDetails(info: DeliveryInfo)
    case orderConfirmation(info: DeliveryInfo)
    case recentOrder(order: Order)
}

// MARK: Route View
extension Route: View {
    var body: some View {
        switch self {
        case .offer(let offer):
            OfferView(offer: offer)
        case .menuSection(let section):
            MenuSectionView(section: section)
        case .menuItem(let item):
            MenuItemView(item: item)
        case .cart:
            CartView()
        case .cartItemOverview(let item):
            CartItemOverview(item: item)
        case .cardDetails(let info):
            PaymentMethodView(info: info)
        case .orderConfirmation(let info):
            OrderConfirmationView(info: info)
        case .recentOrder(let order):
            RecentOrderView(order: order)
        }
    }
}

// MARK: Route Manager
@Observable final class RouteManager {
    /// Tab view tabs
    enum Tab {
        case home, map, menu
        
        var title: String {
            switch self {
            case .home: "Home"
            case .map: "Map"
            case .menu: "Menu"
            }
        }
    }

    /// Selected tab in TabView
    var tabSelection: Tab = .home
    
    /// Navigation path
    var routes = [Route]()
    
    /// Pushing navigation to the `route` only if it's not in path already
    func push(to route: Route) {
        guard !routes.contains(route) else {
            return
        }
        routes.append(route)
    }
    
    /// Resets navigation path to the root and selects home tab
    func reset() {
        routes = []
        tabSelection = .home
    }
    
    /// Removes last components from navigation path navigating user to the previous screen
    func back() {
        _ = routes.popLast()
    }
}
