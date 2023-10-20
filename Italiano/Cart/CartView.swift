//
//  CartView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(\.modelContext) private var context
    
    private let locations: [Location]
    @Query private var items: [CartItem]
    @AppStorage("deliveryOption") private var deliveryOption: DeliveryOption = .delivery
    
    init() {
        let locations = try! JSONDecoder.decode(from: "Locations", type: [Location].self)
        self.locations = locations
        if let loc1 = locations.first {
            _pickupLocation = .init(wrappedValue: loc1)
        }
    }
    
    @State private var deliveryAddress: String = ""
    @State private var pickupLocation: Location = .empty
    
    var body: some View {
        VStack {
            ItemsList
            
            VStack {
                GreenDivider
                    .padding(.vertical)
                
                Group {
                    DeliveryOptionSelector
                    
                    switch deliveryOption {
                    case .delivery:
                        DeliveryAddressField
                            .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                    case .pickup:
                        PickupLocationSelector
                            .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
                    }
                    
                    GreenDivider
                        .padding(.vertical)
                }
                .animation(.smooth, value: deliveryOption)
                
                OrderSummary
                
                ProceedButton
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.selection, trigger: deliveryOption)
    }
    
    private var ProceedButton: some View {
        NavigationLink(value: 1) {
            Text("Proceed")
                .font(.asset.buttonText)
                .padding(.horizontal, 30)
        }
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
        .disabled({
            switch deliveryOption {
            case .delivery:
                return deliveryAddress.isEmpty
            case .pickup:
                return pickupLocation == .empty
            }
        }())
    }
    
    private var ItemsList: some View {
        Group {
            if items.isEmpty {
                ContentUnavailableView("Cart is Empty", systemImage: "cart")
                    .listRowSeparator(.hidden)
            } else {
                List {
                    ForEach(items) { item in
                        NavigationLink(value: Route.cartItemOverview(item)) {
                            CartRowView(item: item)
                        }
                    }
                    .onDelete {
                        guard let index = $0.first else { return }
                        withAnimation {
                            context.delete(items[index])
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
    }
    
    private var OrderSummary: some View {
        let goods = items.map({ $0.totalPrice }).reduce(0, +)
        let delivery: Double = items.isEmpty ? 0 : deliveryOption.price
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
    
    private var PickupLocationSelector: some View {
        Group {
            if locations.isEmpty {
                Text("No pickup locations available")
                    .padding()
            } else {
                Picker(selection: $pickupLocation) {
                    ForEach(locations) { location in
                        Text(location.name)
                            .tag(location)
                    }
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.palette.tomatoRed)
                        .imageScale(.large)
                }
                .pickerStyle(.navigationLink)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.palette.oliveGreen)
                }
            }
        }
        .font(.asset.menuItem)
    }
    
    private var DeliveryAddressField: some View {
        HStack {
            Image(systemName: "location")
                .foregroundStyle(Color.palette.tomatoRed)
                .symbolVariant(.circle)
                .imageScale(.large)
                .padding(.leading)
            
            TextField("Address", text: $deliveryAddress, prompt: Text("Green street, apt. 109, NYC"))
                .padding([.vertical, .trailing])
                .textContentType(.fullStreetAddress)
        }
        .font(.asset.menuItem)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.palette.oliveGreen)
        }
    }
    
    private var DeliveryOptionSelector: some View {
        HStack {
            VStack(spacing: 0) {
                Text("Delivery")
                
                if deliveryOption == .delivery {
                    Line()
                        .stroke(style: .init(lineWidth: 1, dash: [4]))
                        .frame(width: 80, height: 1)
                }
            }
            .onTapGesture {
                deliveryOption = .delivery
            }
            
            Divider()
                .frame(width: 1.5, height: 30)
                .overlay(Color.palette.oliveGreen)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                Text("Pick Up")
                
                if deliveryOption == .pickup {
                    Line()
                        .stroke(style: .init(lineWidth: 1, dash: [4]))
                        .frame(width: 80, height: 1)
                }
            }
            .onTapGesture {
                deliveryOption = .pickup
            }
        }
        .foregroundStyle(Color.palette.oliveGreen)
        .font(.asset.heading2)
    }
    
    private var GreenDivider: some View {
        Divider()
            .frame(height: 1.5)
            .overlay(Color.palette.lightGreen)
    }
}

#Preview {
    @State var cacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        NavigationStack {
            CartView()
                .navigationDestination(for: Route.self) { $0 }
        }
    }
    .environment(cacheManager)
}
