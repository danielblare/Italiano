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
            AsyncImage(url: offer.image) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("")
                    .resizable()
                    .scaledToFill()
            }
            .background(.gray.opacity(0.3))
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
                .foregroundStyle(Color.palette.dark)
                .font(.asset.mainText)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    SwiftDataPreview(preview: PreviewContainer([Offer.self])) {
        OfferCellView(offer: .dummy)
    }
    .frame(width: 100, height: 100)
}
