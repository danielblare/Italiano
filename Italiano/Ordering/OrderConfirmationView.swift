//
//  OrderConfirmationView.swift
//  Italiano
//
//  Created by Daniel on 10/22/23.
//

import SwiftUI
import SwiftData

struct OrderConfirmationView: View {
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    @Environment(\.modelContext) private var context

    @Query private var cartItems: [CartItemSwiftData]
    
    let deliveryInfo: DeliveryInfo
    
    init(info: DeliveryInfo) {
        self.deliveryInfo = info
    }
    
    var body: some View {
        VStack {
            Text("You sure you want to confirm your order?")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading1)
                .multilineTextAlignment(.center)
            
            List(cartItems) {
                CartRowView(item: $0)
            }
            .listStyle(.plain)
            
            VStack {
                GreenDivider

                deliveryInfo.option.orderConfirmationTitle
                    .foregroundStyle(Color.palette.neutralDark)
                    .font(.asset.heading2)
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                switch deliveryInfo.option {
                case .delivery:
                    DeliveryAddress
                case .pickup:
                    PickupLocation
                }
                
                GreenDivider
                    .padding(.vertical)
                
                OrderSummary
                
                HStack {
                    BackButton
                    
                    ConfirmButton
                }

            }
            .padding(.horizontal)
            
        }
        .navigationTitle("Order confirmation")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var BackButton: some View {
        Button {
            dependencies.routeManager.back()
        } label: {
            Text("Back")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 200)
        }
        .buttonStyle(.borderedProminent)
        .tint(.clear)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder()
        }
        .foregroundStyle(Color.palette.tomatoRed)
    }
    
    private var ConfirmButton: some View {
        Button {
            try? dependencies.cartManager.placeOrder(deliveryInfo: deliveryInfo, context: context)
        } label: {
            Text("Confirm")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 200)
        }
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
    }
    
    private var OrderSummary: some View {
        let goods = cartItems.map({ $0.totalPrice }).reduce(0, +)
        let delivery: Double = deliveryInfo.option.price
        let total = goods + delivery
        return Group {
            Text("Order Summary")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Goods:")
                
                Spacer()
                
                Text(goods.formatPrice())
            }
            
            HStack {
                Text("Estimated Delivery:")
                
                Spacer()
                
                Text(delivery.formatPrice())
            }
            
            HStack {
                Text("Total:")
                
                Spacer()
                
                Text(total.formatPrice())
                    .foregroundStyle(Color.palette.tomatoRed)
            }
            .font(.asset.offerText)
            .padding(.vertical)
            
            
        }
        .font(.asset.menuItem)
        .foregroundStyle(Color.palette.neutralDark)
    }

    private var PickupLocation: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .foregroundStyle(Color.palette.tomatoRed)
                .imageScale(.large)
                .padding(.leading)
            
            Text(deliveryInfo.address)
                .foregroundStyle(Color.palette.neutralDark)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.vertical, .trailing])
        }
        .font(.asset.menuItem)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.palette.oliveGreen)
        }
    }
    
    private var DeliveryAddress: some View {
        HStack {
            Image(systemName: "location")
                .foregroundStyle(Color.palette.tomatoRed)
                .symbolVariant(.circle)
                .imageScale(.large)
                .padding(.leading)
            
            Text(deliveryInfo.address)
                .foregroundStyle(Color.palette.neutralDark)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.vertical, .trailing])
        }
        .font(.asset.menuItem)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.palette.oliveGreen)
        }
    }

    private var GreenDivider: some View {
        Divider()
            .frame(height: 1.5)
            .overlay(Color.palette.lightGreen)
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItemSwiftData.dummy]) {
        NavigationStack {
            OrderConfirmationView(info: .dummy)
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
    }
}
