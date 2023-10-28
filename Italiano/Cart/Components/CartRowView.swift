//
//  CartRowView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI

/// Row view of a cart item
struct CartRowView: View {
    
    /// Item passed in
    let item: any CartItem
    
    var body: some View {
        HStack(alignment: .center) {
            CachedImage(url: item.item.image)
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 7)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text(item.item.name)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(item.totalPrice.formatPrice())
                }
                .font(.asset.extra)
                
                HStack(alignment: .top) {
                    Text(item.item.info)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text("Qty: \(item.quantity)")
                    
                }
                .font(.asset.menuItem)
                
                let selectedOptions = item.item.options.filter({ $0.value })
                if !selectedOptions.isEmpty {
                    Text(selectedOptions.map({ $0.name }).joined(separator: ", "))
                        .font(.asset.menuItem)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        CartRowView(item: CartItemSwiftData.dummy)
            .frame(height: 100)
            .padding()
    }
    .environment(dependencies)
}
