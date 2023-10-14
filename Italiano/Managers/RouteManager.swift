//
//  RouteManager.swift
//  Italiano
//
//  Created by Daniel on 10/8/23.
//

import SwiftUI
import Observation

enum Route: Hashable {
    case offer(_ offer: Offer)
    case menuSection(_ section: MenuSection)
}

// MARK: Route View
extension Route: View {
    var body: some View {
        switch self {
        case .offer(let offer):
            OfferView(offer: offer)
        case .menuSection(let section):
            MenuSectionView(section: section)
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
