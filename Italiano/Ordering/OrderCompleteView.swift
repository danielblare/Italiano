//
//  OrderCompleteView.swift
//  Italiano
//
//  Created by Daniel on 10/22/23.
//

import SwiftUI

/// Screen indicating that order has been placed
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
    
    /// Button to dismiss the view and reset nav route
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
        .accessibilityIdentifier("MainScreen")
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
    }

}

#Preview {
    @State var dependencies = Dependencies()

    return OrderCompleteView()
        .environment(dependencies)
}
