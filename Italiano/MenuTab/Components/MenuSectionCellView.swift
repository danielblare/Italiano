//
//  MenuSectionCellView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI

/// Cell view for menu section
struct MenuSectionCellView: View {
    
    /// Menu section passed in
    let section: MenuSection
    
    var body: some View {
        VStack {
            CachedImage(url: section.image)
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))

            
            Text(section.name)
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        MenuSectionCellView(section: .dummy)
    }
    .frame(width: 100, height: 100)
    .environment(dependencies)
}
