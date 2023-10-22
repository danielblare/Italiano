//
//  OrderCompleteView.swift
//  Italiano
//
//  Created by Daniel on 10/22/23.
//

import SwiftUI

struct OrderCompleteView: View {
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Group {
                Text("Thank you!!!")
                    .font(.asset.heading1)
                
                Text("Your order has been successful and is being prepared")
                    .font(.asset.heading2)
                    .fontWeight(.regular)
            }
            .foregroundStyle(Color.palette.oliveGreen)
            .multilineTextAlignment(.center)
            
            Image("order_complete")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
            ProceedButton
                .padding(.vertical)
        }
        .padding()
    }
    
    private var ProceedButton: some View {
        Button {
            dependencies.routeManager.reset()
            dismiss.callAsFunction()
        } label: {
            Text("Main screen")
                .font(.asset.buttonText)
                .padding(.vertical, 5)
                .frame(maxWidth: 200)
        }
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
    }

}

#Preview {
    @State var dependencies = Dependencies()

    return OrderCompleteView()
        .environment(dependencies)
}
