//
//  MenuSectionView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI

struct MenuSectionView: View {
    
    let section: MenuSection
    
    var body: some View {
        ScrollView {
            VStack {
                Text(section.name)
                    .font(.asset.heading1)
                    .foregroundStyle(Color.palette.oliveGreen)
                
                Button {
                    
                } label: {
                    Image("build_your_own")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(Color.palette.lightGreen)
                
                Text("Select from menu")
                    .font(.asset.heading1)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.palette.oliveGreen)
                
                ForEach(section.items.sorted(by: { $0.price < $1.price })) { item in
                    NavigationLink(value: Route.menuItem(item)) {
                        MenuItemRowView(item: item)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                
            }
            .padding()
        }
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()
    @State var cacheManager: CacheManager = CacheManager()
    
    return NavigationStack {
        SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
            MenuSectionView(section: .dummy)
        }
        .environment(routeManager)
        .environment(cacheManager)
        .navigationBarTitleDisplayMode(.inline)
    }
}
