//
//  MenuItemRowView.swift
//  Italiano
//
//  Created by Daniel on 10/15/23.
//

import SwiftUI

struct MenuItemRowView: View {
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
    SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        MenuItemRowView(item: .dummy)
            .padding()
    }
}
