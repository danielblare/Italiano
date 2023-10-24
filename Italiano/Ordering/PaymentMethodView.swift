//
//  PaymentMethodView.swift
//  Italiano
//
//  Created by Daniel on 10/21/23.
//

import SwiftUI
import SwiftData

struct PaymentMethodView: View {
    
    let deliveryInfo: DeliveryInfo
    
    init(info: DeliveryInfo) {
        self.deliveryInfo = info
    }
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    
    @Query private var items: [CartItemSwiftData]
    
    @AppStorage("paymentMethod") private var selectedMethod: PaymentMethod = .creditCard
    @AppStorage("defaultCardDetails") private var cardDetails: CardDetails = .init()
    
    @FocusState private var focused: CardDetails.Field?
    
    var body: some View {
        ScrollView {
            VStack {
                OrderSummary
                
                GreenDivider
                    .padding(.vertical)
                
                Group {
                    MethodSelector
                        .padding(.bottom)
                    
                    switch selectedMethod {
                    case .applePay:
                        Text("Apple Pay")
                    case .payPal:
                        Text("PayPal")
                    case .creditCard:
                        CardDetailsForm
                    }
                    
                    HStack {
                        BackButton
                        
                        ProceedButton
                    }
                    .padding(.top, 30)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Card details")
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
    
    private var ProceedButton: some View {
        Button {
            dependencies.routeManager.push(to: .orderConfirmation(info: deliveryInfo))
        } label: {
            Text("Proceed")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 200)
        }
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
        .disabled(focused != nil)
        .disabled({
            switch selectedMethod {
            case .applePay, .payPal: false
            case .creditCard: !cardDetails.validate()
            }
        }())
    }
    
    private var CardDetailsForm: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "creditcard")
                    .foregroundStyle(Color.palette.lightGreen)
                    .imageScale(.large)
                    .padding(.leading)
                
                TextField("Card Number", text: .init {
                    cardDetails.number
                } set: { value in
                    let sanitizedValue = value.filter { "0123456789".contains($0) }
                    let spaceSeparatedValue = sanitizedValue
                        .enumerated()
                        .map { (index, char) in
                            return (index > 0 && index % 4 == 0 && char != " ") ? " " + String(char) : String(char)
                        }
                        .joined()
                    cardDetails.number = spaceSeparatedValue.prefix(19).description
                }, prompt: Text("4444 1111 3333 2222"))
                .onSubmit { focused = .expiration }
                .focused($focused, equals: .number)
                .textContentType(.creditCardNumber)
                .padding([.vertical, .trailing])
            }
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(cardDetails.validate(field: .number) ? Color.palette.oliveGreen : Color.palette.tomatoRed)
            }
            
            HStack(spacing: 20) {
                TextField("Expiration Date", text: .init {
                    cardDetails.expiration
                } set: { value in
                    let sanitizedValue = value.filter { "0123456789".contains($0) }
                    
                    if sanitizedValue.count >= 3 {
                        let month = sanitizedValue.prefix(2)
                        let year = sanitizedValue.suffix(2)
                        cardDetails.expiration = "\(month)/\(year)"
                    } else {
                        cardDetails.expiration = sanitizedValue
                    }
                }, prompt: Text("12/24"))
                .onSubmit { focused = .cvv }
                .focused($focused, equals: .expiration)
                .multilineTextAlignment(.center)
                .textContentType(.creditCardExpiration)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(cardDetails.validate(field: .expiration) ? Color.palette.oliveGreen : Color.palette.tomatoRed)
                }
                
                HStack {
                    Text("CVV")
                        .padding(.leading)
                    
                    TextField("CVV", text: .init {
                        cardDetails.cvv
                    } set: { value in
                        let sanitizedValue = value.filter { "0123456789".contains($0) }
                        cardDetails.cvv = sanitizedValue.prefix(3).description
                    }, prompt: Text("123"))
                    .focused($focused, equals: .cvv)
                    .multilineTextAlignment(.center)
                    .textContentType(.creditCardSecurityCode)
                    .padding(.trailing)
                    .padding(.vertical, 10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(cardDetails.validate(field: .cvv) ? Color.palette.oliveGreen : Color.palette.tomatoRed)
                }
            }
        }
        .keyboardType(.numberPad)
        .font(.asset.menuItem)
    }
    
    private var MethodSelector: some View {
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
        let delivery: Double = items.isEmpty ? 0 : deliveryInfo.option.price
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
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: [CartItemSwiftData.dummy]) {
        NavigationStack {
            PaymentMethodView(info: .dummy)
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
    }
}
