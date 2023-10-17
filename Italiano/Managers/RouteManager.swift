//
//  RouteManager.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI

enum Route: Hashable {
    case offer(_ offer: Offer)
    case menuSection(_ section: MenuSection)
    case menuItem(_ item: MenuItem)
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
        }
    }
}

// MARK: Route Manager
@Observable final class RouteManager {
    var routes = [Route]()
    
    func push(to route: Route) {
        guard !routes.contains(route) else {
            return
        }
        routes.append(route)
    }
    
    func reset() {
        routes = []
    }
    
    func back() {
        _ = routes.popLast()
    }
}
