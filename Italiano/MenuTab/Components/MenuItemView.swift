//
//  MenuItemView.swift
//  Italiano
//
//  Created by Daniel on 10/16/23.
//

import SwiftUI
import SwiftData

struct MenuItemView: View {
    @Environment(\.modelContext) private var context
    @State private var item: MenuItem
    
    @Query private var cartItems: [CartItem]

    init(item: MenuItem) {
        self._item = .init(wrappedValue: item)
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                CachedImage(url: item.image)
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom)
                
                Group {
                    Text(item.name)
                        .font(.asset.heading1)
                    
                    Text(item.info)
                        .font(.asset.menuItem)
                }
                .foregroundStyle(Color.palette.oliveGreen)
                
                Text(item.price.formatPrice())
                    .font(.asset.heading2)
                    .foregroundStyle(Color.palette.tomatoRed)
                    .padding(.vertical, 10)
                
                Group {
                    if !item.ingredients.isEmpty {
                        GroupBox {
                            Text("Ingredients:")
                                .foregroundStyle(Color.palette.oliveGreen)
                                .font(.asset.extra)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(item.ingredients.map({ $0.name }).joined(separator: ", "))
                                .font(.asset.menuItem)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    if !item.options.isEmpty {
                        GroupBox {
                            Text("Options:")
                                .foregroundStyle(Color.palette.oliveGreen)
                                .font(.asset.extra)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(item.options) { option in
                                let binding = Binding<Option> { option } set: {
                                    guard let index = item.options.firstIndex(of: option) else { return }
                                    item.options[index] = $0
                                }
                                VStack {
                                    OptionView(option: binding)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                
                Button {
                    print(item)
                    if let index = cartItems.firstIndex(where: { $0.item == item }) {
                        cartItems[index].quantity += 1
                    } else {
                        let newItem = CartItem(item: item)
                        context.insert(newItem)
                    }
                } label: {
                    Text("Add to cart")
                        .font(.asset.buttonText)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.palette.tomatoRed)
                .padding(.vertical)
            }
            .padding()
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        MenuItemView(item: .dummy)
            .environment(cacheManager)
    }
}
