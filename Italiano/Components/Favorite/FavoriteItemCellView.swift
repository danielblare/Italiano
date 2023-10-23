//
//  FavoriteItemCellView.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import SwiftUI

struct FavoriteItemCellView: View {
    let item: FavoriteItem
    
    var body: some View {
        VStack {
            CachedImage(url: item.item.image)
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            
            VStack {
                Text(item.item.name)
                    .lineLimit(2)
                
                let selectedOptions = item.item.options.filter({ $0.value })
                if !selectedOptions.isEmpty {
                    Text("options")
                        .foregroundStyle(Color.palette.neutralDark)
                }
            }
            .font(.asset.mainText)
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        FavoriteItemCellView(item: .dummy)
    }
    .frame(width: 100, height: 100)
    .environment(dependencies)
}
