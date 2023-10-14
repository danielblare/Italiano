//
//  OfferView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI

/// Full offer page view
struct OfferView: View {
    
    /// Offer passed in
    let offer: Offer
    
    /// Triggers when user copied promo code to the clipboard
    @State private var isCopied: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    CachedImage(url: offer.image)
                        .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
                    
                    Text(offer.offerText)
                        .font(.asset.custom(size: 24))
                        .foregroundStyle(Color.palette.oliveGreen)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    
                    Text(offer.text)
                        .font(.asset.custom(size: 18))
                    
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.horizontal)
            }
            
            let promoCode = offer.promoCode.uppercased()
            Text("Promo Code")
                .font(.asset.custom(size: 20))
                .fontWeight(.semibold)
            
            Text(promoCode)
                .monospaced()
                .font(.largeTitle)
                .fontWeight(.bold)
            
                .padding()
                .background(Color.palette.tomatoRed.opacity(0.5))
                .overlay {
                    if isCopied {
                        ZStack {
                            Color.palette.neutralDark
                            
                            Text("Copied")
                                .font(.asset.custom(size: 30))
                        }
                    }
                }
            
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
                .animation(.interactiveSpring, value: isCopied)
                .sensoryFeedback(.selection, trigger: isCopied) { $1 }
                .onTapGesture {
                    if !isCopied {
                        UIPasteboard.general.string = promoCode
                        isCopied = true
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                            isCopied = false
                        }
                    }
                }
            
            Text("Click to copy")
                .font(.asset.custom(size: 16))
                .foregroundStyle(.secondary)


        }
        .navigationTitle(offer.title)
    }
}

#Preview {
    @State var routeManager: RouteManager = RouteManager()
    @State var cacheManager: CacheManager = CacheManager()

    return NavigationStack {
        SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
            OfferView(offer: .dummy)
        }
        .environment(routeManager)
        .environment(cacheManager)
        .navigationBarTitleDisplayMode(.inline)
    }
}
