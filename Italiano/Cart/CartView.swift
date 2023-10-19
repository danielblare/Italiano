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
    
    @Query private var items: [CartItem]
    
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
                Divider()
                    .frame(height: 1.5)
                    .overlay(Color.palette.lightGreen)
                    .padding(.vertical)

                HStack {
                    Text("Delivery")
                    
                    Divider()
                        .frame(width: 1.5, height: 30)
                        .overlay(Color.palette.oliveGreen)
                        .padding(.horizontal)

                    Text("Pick Up")
                }
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                
                TextField(text: .constant("")) {
                    Label("", systemImage: "cart")
                }
                .padding()
                .background(.secondary.opacity(0.3))
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(Color.palette.lightGreen)
                    .padding(.vertical)

                
                
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
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
