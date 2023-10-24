//
//  CartItemOverview.swift
//  Italiano
//
//  Created by Daniel on 10/19/23.
//

import SwiftUI
import SwiftData

struct CartItemOverview: View {
    
    @Bindable var cartItem: CartItemSwiftData
    
    init(item: CartItemSwiftData) {
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
                        
                        let selectedOptions = item.options.filter({ $0.value })
                        if !selectedOptions.isEmpty {
                            GroupBox {
                                Text("Options:")
                                    .foregroundStyle(Color.palette.oliveGreen)
                                    .font(.asset.extra)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(selectedOptions.map({ $0.name }).joined(separator: ", "))
                                    .font(.asset.menuItem)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }                        
                    }
                    .multilineTextAlignment(.leading)
                }
                .padding()
            }
            
            VStack {
                Stepper("Qty: \(cartItem.quantity)", value: $cartItem.quantity, in: 1...49, step: 1)
                
                HStack {
                    Text("Total:")
                    
                    Spacer()
                    
                    Text(cartItem.totalPrice.formatPrice())
                        .padding(.top)
                }
            }
            .font(.asset.heading2)
            .padding()
            
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var dependencies = Dependencies()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            CartItemOverview(item: .dummy)
        }
        .environment(dependencies)
    }
}
