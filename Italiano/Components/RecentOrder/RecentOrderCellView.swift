//
//  RecentOrderCellView.swift
//  Italiano
//
//  Created by Daniel on 10/23/23.
//

import SwiftUI

/// Cell View for recent order
struct RecentOrderCellView: View {
    
    /// Order passed in
    let order: Order
    
    /// Date formatted to look like `Oct 11`
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: order.date)
    }
    
    var body: some View {
        VStack {
            CachedImage(url: order.items.first!.item.image)
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Group {
                Text(formattedDate)
                
                Text(order.totalPrice.formatPrice())
            }
            .font(.asset.mainText)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        RecentOrderCellView(order: .dummy)
    }
    .frame(width: 100, height: 100)
    .environment(dependencies)
}
