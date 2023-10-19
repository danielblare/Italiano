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
    }
    @Environment(\.modelContext) private var context
    
    @Query private var items: [CartItem]
    @State private var deliveryOption: DeliveryOption = .delivery
    
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
                
                DeliveryOptionSelector
                
                TextField(text: .constant("")) {
                    Label("", systemImage: "cart")
                }
                .padding()
                .background(.secondary.opacity(0.3))
                
                GreenDivider
                    .padding(.vertical)

                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
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
        .animation(.smooth, value: deliveryOption)
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
