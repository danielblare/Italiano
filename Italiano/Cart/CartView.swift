//
//  CartView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI
import SwiftData

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}


struct CartView: View {
    enum DeliveryOption {
        case delivery, pickup
        
        var price: Double {
            switch self {
            case .delivery: return 15
            case .pickup: return 0
            }
        }
    }
    @Environment(\.modelContext) private var context
    
    
    private let locations: [Location] = try! JSONDecoder.decode(from: "Locations", type: [Location].self)
    @Query private var items: [CartItem]
    @State private var deliveryOption: DeliveryOption = .pickup
    
    
    @State private var deliveryAddress: String = ""
    @State private var pickupLocation: Location? = nil
    
    var body: some View {
        VStack {
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
//                    .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
            }
            
            VStack {
                GreenDivider
                    .padding(.vertical)
                
                Group {
                    DeliveryOptionSelector
                    
                    switch deliveryOption {
                    case .delivery:
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
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing)))
                    case .pickup:
                        Picker(selection: $pickupLocation) {
                            ForEach(locations) {
                                Text($0.name)
                            }
                        } label: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundStyle(Color.palette.tomatoRed)
                                .imageScale(.large)
                        }
                        .pickerStyle(.navigationLink)
                        .padding(12)
                        .font(.asset.menuItem)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color.palette.oliveGreen)
                        }
                        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
                    }
                    
                    
                    GreenDivider
                        .padding(.vertical)
                }
                .animation(.smooth, value: deliveryOption)

                let goods = items.map({ $0.totalPrice }).reduce(0, +)
                let delivery: Double = items.isEmpty ? 0 : deliveryOption.price
                let total = goods + delivery
                Group {
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
                
                Button {
                    
                } label: {
                    Text("Proceed")
                        .font(.asset.buttonText)
                        .padding(.horizontal, 30)
                }
                .buttonStyle(.borderedProminent)
                .tint(.palette.tomatoRed)
                
            }
            .padding(.horizontal)
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.selection, trigger: deliveryOption)
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
