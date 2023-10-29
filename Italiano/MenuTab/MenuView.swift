//
//  MenuView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI
import SwiftData

/// Menu page displaying menu sections
struct MenuView: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies

    /// Menu sections
    @Query(sort: \MenuSection.name, order: .reverse) private let sections: [MenuSection]

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
    @State var dependencies = Dependencies()
    @Bindable var routeManager = dependencies.routeManager

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) {
        NavigationStack(path: $routeManager.routes) {
            MenuView()
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
    }
    
}
