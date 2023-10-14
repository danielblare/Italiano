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
        Text(section.name)
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
