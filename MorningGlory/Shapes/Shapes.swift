//
//  Shapes.swift
//  MorningGlory
//
//  Created by 최대성 on 9/19/24.
//

import SwiftUI

//MARK: 특정 모서리 깎기
struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
