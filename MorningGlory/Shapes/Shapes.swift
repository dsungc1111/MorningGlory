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

//MARK: 배경색
struct ViewBackground: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#82bbf8"), Color(hex: "#F3D8A3")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    
}

//MARK: 포스트잇 접힌 부분
struct FoldedCornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 오른쪽 위부터 시작해서 시계 방향으로 경로를 그립니다.
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 20))
        path.addArc(center: CGPoint(x: rect.maxX - 20, y: rect.maxY - 20),
                    radius: 20,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                          control: CGPoint(x: rect.midX, y: rect.midY)) 
        return path
    }
}
