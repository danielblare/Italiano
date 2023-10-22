//
//  MenuView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI

struct MenuView: View {
    
    @Environment(Dependencies.self) private var dependencies

    private let sections: [MenuSection]
    
    init() {
        self.sections = (try? JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) ?? [].sorted { $0.name > $1.name }
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
    @State var dependencies = Dependencies()
    @Bindable var routeManager = dependencies.routeManager

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack(path: $routeManager.routes) {
            MenuView()
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
    }
    
}
