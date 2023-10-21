//
//  CardDetailsInputView.swift
//  Italiano
//
//  Created by Daniel on 10/21/23.
//

import SwiftUI
import SwiftData

enum PaymentMethod: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case applePay
    case payPal
    case creditCard
    
    var buttonText: String {
        switch self {
        case .applePay: "Pay with Apple Pay"
        case .payPal: "Pay with PayPal"
        case .creditCard: "Pay with credit/debit card"
        }
    }
}

struct CardDetailsInputView: View {
    enum Field {
        case number, expiration, cvv
    }
    
    let deliveryOption: DeliveryOption
    let address: String
    
    @Query private var items: [CartItem]
    
    @AppStorage("paymentMethod") private var selectedMethod: PaymentMethod = .creditCard
    
    @FocusState private var focused: Field?
    
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                OrderSummary
                
                GreenDivider
                    .padding(.vertical)
                
                Group {
                    ButtonsSection
                        .padding(.bottom)
                    
                    switch selectedMethod {
                    case .applePay:
                        Text("Apple Pay")
                    case .payPal:
                        Text("PayPal")
                    case .creditCard:
                        CardDetailsForm
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Card details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var CardDetailsForm: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "creditcard")
                    .foregroundStyle(Color.palette.lightGreen)
                    .imageScale(.large)
                    .padding(.leading)
                
                TextField("Card Number",
                          text: .init {
                    cardNumber
                } set: { value in
                    cardNumber = value
                },
                          prompt: Text("4444 1111 3333 2222"))
                .onSubmit { focused = .expiration }
                .focused($focused, equals: .number)
                .padding([.vertical, .trailing])
                .textContentType(.creditCardNumber)
            }
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.palette.oliveGreen)
            }
            
            HStack(spacing: 20) {
                TextField("Expiration Date", text: $expirationDate, prompt: Text("12/24"))
                    .onSubmit { focused = .cvv }
                    .focused($focused, equals: .expiration)
                    .multilineTextAlignment(.center)
                    .textContentType(.creditCardExpiration)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color.palette.oliveGreen)
                    }
                
                HStack {
                    Text("CVV")
                        .padding(.leading)
                    
                    TextField("CVV", text: $expirationDate, prompt: Text("123"))
                        .focused($focused, equals: .cvv)
                        .multilineTextAlignment(.center)
                        .textContentType(.creditCardSecurityCode)
                        .padding(.trailing)
                        .padding(.vertical, 10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.palette.oliveGreen)
                }
            }
        }
        .keyboardType(.numberPad)
        .font(.asset.menuItem)
    }
    
    private var ButtonsSection: some View {
        VStack(spacing: 15) {
            ForEach(PaymentMethod.allCases) { method in
                Button {
                    selectedMethod = method
                } label: {
                    Text(method.buttonText)
                        .font(.asset.buttonText)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.clear)
                .background {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.palette.creamyBeige)
                        if selectedMethod == method {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(lineWidth: 1.5)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: .init(dash: [4]))
                        }
                    }
                }
                .foregroundStyle(Color.palette.tomatoRed)
            }
        }
        .animation(.snappy, value: selectedMethod)
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
            }
            .font(.asset.offerText)
            .padding(.top)
        }
        .font(.asset.menuItem)
        .foregroundStyle(Color.palette.neutralDark)
    }
    
    private var GreenDivider: some View {
        Divider()
            .frame(height: 1.5)
            .overlay(Color.palette.lightGreen)
    }
    
}

#Preview {
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItem.dummy]) {
        NavigationStack {
            CardDetailsInputView(deliveryOption: .delivery, address: "TestAddress")
        }
    }
}
