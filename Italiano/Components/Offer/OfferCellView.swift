//
//  OfferCellView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI

/// Offer Cell view
struct OfferCellView: View {
    
    /// Offer taken to display
    let offer: Offer
    
    var body: some View {
        VStack {
            CachedImage(url: offer.image)
                .scaledToFill()
                .overlay(alignment: .topTrailing) { // Displaying badge if there is one
                    if let badge = offer.badge {
                        Text(badge)
                            .foregroundStyle(.white)
                            .font(.footnote)
                            .fontWeight(.bold)
                        
                            .padding(2)
                            .background(.red)
                            .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 5))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
            Text(offer.title)
                .font(.asset.mainText)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        OfferCellView(offer: .dummy)
    }
    .frame(width: 100, height: 100)
    .environment(dependencies)
}
