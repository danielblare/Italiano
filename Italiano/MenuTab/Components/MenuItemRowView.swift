//
//  MenuItemRowView.swift
//  Italiano
//
//  Created by Daniel on 10/15/23.
//

import SwiftUI
import SwiftData

/// Row view for menu item
struct MenuItemRowView: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    
    /// Model context
    @Environment(\.modelContext) private var context
    
    /// Cart items to modify when adding to the cart
    @Query private var cartItems: [CartItemSwiftData]
    
    /// Menu item passed in
    let item: MenuItem
    
    var body: some View {
        HStack {
            CachedImage(url: item.image)
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            VStack(spacing: 10) {
                Text(item.name)
                    .lineLimit(2)
                
                Text(item.price.formatPrice())
                    .foregroundStyle(Color.palette.oliveGreen)
                
                Button {
                    dependencies.cartManager.addToCart(item: item, cart: cartItems, context: context)
                } label: {
                    Text("Add to cart")
                        .font(.asset.mainText)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.palette.tomatoRed)
            }
            .font(.asset.menuItem)
            .frame(maxWidth: .infinity)
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.palette.lightGreen)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.palette.creamyBeige)
                .strokeBorder(Color.palette.lightGreen, lineWidth: 1)
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        MenuItemRowView(item: .dummy)
            .padding()
    }
    .environment(dependencies)
}
