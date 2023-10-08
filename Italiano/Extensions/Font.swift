//
//  Font.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI

extension Font {
    
    /// Custom font asset
    static let asset = Asset()
    
    struct Asset {
        let heading1 = Font.custom("Aleo", size: 32).bold()
        let heading2 = Font.custom("Aleo", size: 24).bold()
        let subHeading = Font.custom("Aleo", size: 24)
        let buttonText = Font.custom("Aleo", size: 22)
        let extra = Font.custom("Aleo", size: 20)
        let menuItem = Font.custom("Aleo", size: 16)
        let mainText = Font.custom("Aleo", size: 14)
        
        func custom(size: CGFloat) -> Font {
            .custom("Aleo", fixedSize: size)
        }
    }
}
