//
//  MenuView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(RouteManager.self) private var routeManager
    
    private let sections: [MenuSection]
    
    init(sections: [MenuSection]) {
        self.sections = sections.sorted { $0.name > $1.name }
    }
    
    var body: some View {
        ScrollView {
            Text("Savor Authentic Italian\nFlavors at Italiano\nExplore Our Menu!")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.extra)
                .multilineTextAlignment(.center)
                .padding()
            
            if sections.isEmpty {
                ContentUnavailableView("Menu is empty", systemImage: "takeoutbag.and.cup.and.straw")
                    .padding(.top, 200)
            } else {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 50) {
                    ForEach(sections) { section in
                        NavigationLink(value: Route.menuSection(section)) {
                            MenuSectionCellView(section: section)
                                .frame(width: 150)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()
    @State var routeManager: RouteManager = RouteManager()
    @Bindable var man = routeManager

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack(path: $man.routes) {
            MenuView(sections: try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self))
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(cacheManager)
        .environment(routeManager)
    }
    
}
