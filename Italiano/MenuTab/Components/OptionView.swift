//
//  OptionView.swift
//  Italiano
//
//  Created by Daniel on 10/17/23.
//

import SwiftUI
import SwiftData

/// View for menu item option with ability to select/unselect it
struct OptionView: View {
    
    /// Option passed in
    @Binding var option: Option
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.palette.lightGreen, lineWidth: 1.5)
                .overlay {
                    if option.value == true {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.palette.oliveGreen)
                            .fontWeight(.bold)
                    }
                }
                .frame(width: 25, height: 25)
            
            Text(option.name)
                .font(.asset.menuItem)
        }
        .onTapGesture {
            option.value.toggle()
        }
        .animation(.interactiveSpring, value: option.value)
        .sensoryFeedback(.selection, trigger: option.value)

    }
}

#Preview {
    OptionView(option: .constant(.dummy))
}
