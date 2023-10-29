//
//  ItemAddedView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI

/// Screen to display "Item has been added" to user
struct ItemAddedView: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    @Environment(\.dismiss) private var dismiss

    /// Menu Item passed in
    let item: MenuItem
        
    var body: some View {
        VStack {
            Spacer()
            
            Group {
                CachedImage(url: item.image)
                    .scaledToFill()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom)
                
                Group {
                    HStack(alignment: .top) {
                        Text(item.name)
                        
                        Spacer()
                        
                        Text(item.price.formatPrice())
                    }
                    .font(.asset.subHeading)
                    
                    
                    Text(item.info)
                        .font(.asset.menuItem)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Item added!")
                        .font(.asset.heading1)
                        .padding(.vertical)
                    
                }
                .foregroundStyle(Color.palette.oliveGreen)
            }
            .frame(width: 250)
            
            ContinueButton
            
            ViewCartButton
            
            Spacer()
        }
    }
    
    /// View Cart Button, leads user to the cart screen
    private var ViewCartButton: some View {
        Button {
            dependencies.routeManager.push(to: .cart)
            dismiss.callAsFunction()
        } label: {
            Text("View cart")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 250)
        }
        .buttonStyle(.borderedProminent)
        .tint(.clear)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder()
        }
        .foregroundStyle(Color.palette.tomatoRed)
    }
    
    /// Continue Button dismissing current view
    private var ContinueButton: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Text("Continue ordering")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 250)
        }
        .buttonStyle(.borderedProminent)
        .padding(.vertical)
        .tint(.palette.tomatoRed)
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            ItemAddedView(item: .dummy)
        }
    }
    .environment(dependencies)
}
