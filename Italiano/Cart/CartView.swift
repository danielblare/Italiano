//
//  CartView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI
import SwiftData

struct CartView: View {
    
    @Query private var items: [CartItem]
    
    var body: some View {
        VStack {
            List {
                if items.isEmpty {
                    ContentUnavailableView("Cart is Empty", systemImage: "cart")
                        .padding(.vertical)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(items) {
                        CartRowView(item: $0)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.inset)
            
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
//        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var cacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        NavigationStack {
            CartView()
        }
    }
    .environment(cacheManager)
}
