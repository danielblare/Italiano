//
//  MenuView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    
    @State private var routeManager: RouteManager = RouteManager()

//    @Query(sort: \MenuSection.name, order: .reverse) private var sections: [MenuSection]
    @State private var sections: [MenuSection] = try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self)
    
    var body: some View {
        @Bindable var routeManager = routeManager
        NavigationStack(path: $routeManager.routes) {
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
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .environment(self.routeManager)
            .navigationDestination(for: Route.self) { $0 }
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
            MenuView()
        .environment(cacheManager)
    }

}
