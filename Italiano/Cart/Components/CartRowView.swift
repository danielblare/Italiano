//
//  CartRowView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI

struct CartRowView: View {
    let item: CartItem
    
    var body: some View {
        HStack(alignment: .top) {
            CachedImage(url: item.item.image)
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(item.item.name)
                    .font(.asset.buttonText)
                
                Text(item.item.info)
                    .font(.asset.menuItem)
                
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing, spacing: 10) {
                Text(item.totalPrice.formatPrice())
                    .font(.asset.buttonText)

                Text("Qty: \(item.quantity)")
                    .font(.asset.menuItem)
                
            }
            .padding(10)
        }
    }
}

#Preview {
    @State var cacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        CartRowView(item: .dummy)
    }
    .environment(cacheManager)
}
