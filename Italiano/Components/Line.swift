//
//  Line.swift
//  Italiano
//
//  Created by Daniel on 10/20/23.
//

import SwiftUI

/// Simple line view
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

#Preview {
    Line()
}
