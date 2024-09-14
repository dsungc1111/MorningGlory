//
//  TimeCircleWrapper.swift
//  MorningGlory
//
//  Created by 최대성 on 9/13/24.
//

import SwiftUI

private struct TimeCircleWrapper: ViewModifier {
    
    let circle: Circle
  
    func body(content: Content) -> some View {
        
        if #available(iOS 16.0, *) {
            circle
                .fill(.blue)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.5), radius: 1)), in: Circle())
        } else {
            circle
                .fill(Color.blue)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(Color.white)
                .shadow(color: .black.opacity(0.5), radius: 1)
        }
    }
}


extension View {
    
    func timeCircle(circle: Circle) -> some View {
        modifier(TimeCircleWrapper(circle: circle))
    }
    
}

