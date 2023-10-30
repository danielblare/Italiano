//
//  CartItemOverview.swift
//  Italiano
//
//  Created by Daniel on 10/19/23.
//

import SwiftUI
import SwiftData

/// Overview for a cart item allowing to change some details
struct CartItemOverview: View {
    
    /// Cart item passed in
    @Bindable var cartItem: CartItemSwiftData
    
    init(item: CartItemSwiftData) {
        self.cartItem = item
    }
    
    var body: some View {
        let menuItem = cartItem.item
        VStack {
            ScrollView {
                VStack() {
                    CachedImage(url: menuItem.image)
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom)
                    
                    Group {
                        Text(menuItem.name)
                            .font(.asset.heading1)
                        
                        Text(menuItem.info)
                            .font(.asset.menuItem)
                    }
                    .foregroundStyle(Color.palette.oliveGreen)
                    
                    Text(menuItem.price.formatPrice())
                        .font(.asset.heading2)
                        .foregroundStyle(Color.palette.tomatoRed)
                        .padding(.vertical, 10)
                    
                    Group {
                        if !menuItem.ingredients.isEmpty {
                            GroupBox {
                                Text("Ingredients:")
                                    .foregroundStyle(Color.palette.oliveGreen)
                                    .font(.asset.extra)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(menuItem.ingredients.map({ $0.name }).joined(separator: ", "))
                                    .font(.asset.menuItem)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        let selectedOptions = menuItem.options.filter({ $0.value })
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
                Stepper(value: $cartItem.quantity, in: 1...49, step: 1) {
                    Text("Qty: \(cartItem.quantity)")
                        .accessibilityIdentifier("Qty")
                }
                
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
        .navigationTitle(menuItem.name)
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(trigger: cartItem.quantity) { $0 < $1 ? .increase : .decrease}
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
