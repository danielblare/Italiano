//
//  CartItemOverview.swift
//  Italiano
//
//  Created by Daniel on 10/19/23.
//

import SwiftUI

struct CartItemOverview: View {
    
    let cartItem: CartItem
    
    init(item: CartItem) {
        self.cartItem = item
    }
    
    var body: some View {
        let item = cartItem.item
        VStack {
            ScrollView {
                VStack() {
                    CachedImage(url: item.image)
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom)
                    
                    Group {
                        Text(item.name)
                            .font(.asset.heading1)
                        
                        Text(item.info)
                            .font(.asset.menuItem)
                    }
                    .foregroundStyle(Color.palette.oliveGreen)
                    
                    Text(item.price.formatPrice())
                        .font(.asset.heading2)
                        .foregroundStyle(Color.palette.tomatoRed)
                        .padding(.vertical, 10)
                    
                    Group {
                        if !item.ingredients.isEmpty {
                            GroupBox {
                                Text("Ingredients:")
                                    .foregroundStyle(Color.palette.oliveGreen)
                                    .font(.asset.extra)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(item.ingredients.map({ $0.name }).joined(separator: ", "))
                                    .font(.asset.menuItem)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        if !item.options.isEmpty {
                            GroupBox {
                                Text("Options:")
                                    .foregroundStyle(Color.palette.oliveGreen)
                                    .font(.asset.extra)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(item.options) { option in
                                    VStack {
                                        OptionView(option: .constant(option))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
                .padding()
            }
            
            HStack {
                Text("Qty: \(cartItem.quantity)")
                
                Spacer()
                
                Text("Total: \(cartItem.totalPrice.formatPrice())")
            }
            .font(.asset.heading2)
            .padding()

        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            CartItemOverview(item: .dummy)
        }
            .environment(cacheManager)
    }
}
