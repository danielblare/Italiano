//
//  RecentOrderView.swift
//  Italiano
//
//  Created by Daniel on 10/24/23.
//

import SwiftUI

struct RecentOrderView: View {
    let order: Order
    
    var body: some View {
        VStack {
            List(order.items, id: \.self) {
                CartRowView(item: $0)
            }
            .listStyle(.plain)
            
            VStack {
                
                GreenDivider
                
                order.deliveryInfo.option.orderConfirmationTitle
                    .foregroundStyle(Color.palette.neutralDark)
                    .font(.asset.heading2)
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)

                switch order.deliveryInfo.option {
                case .delivery:
                    DeliveryAddress
                case .pickup:
                    PickupLocation
                }
                
                GreenDivider
                    .padding(.vertical)
                
                OrderSummary
            }
            .padding(.horizontal)
        }
    }
    
    private var PickupLocation: some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
                .foregroundStyle(Color.palette.tomatoRed)
                .imageScale(.large)
                .padding(.leading)
            
            Text(order.deliveryInfo.address)
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
            
            Text(order.deliveryInfo.address)
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
    
    private var OrderSummary: some View {
        let goods = order.items.map({ $0.totalPrice }).reduce(0, +)
        let delivery: Double = order.deliveryInfo.option.price
        let total = goods + delivery
        return Group {
            HStack {
                Text("Order Placed")
                
                Spacer()
                
                Text(order.date.formatted())
            }
            
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
}

#Preview {
    @State var dependencies = Dependencies()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            RecentOrderView(order: .dummy)
        }
        .environment(dependencies)
    }
}
