//
//  Text+.swift
//  MorningGlory
//
//  Created by 최대성 on 9/24/24.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content.font(.custom(weight == .bold ? "HakgyoansimDunggeunmisoOTF-B" : "HakgyoansimDunggeunmisoOTF-R", size: size))
    }
}


extension View {
    
    func customFontRegular(size: CGFloat) -> some View {
          self.modifier(CustomFontModifier(size: size, weight: .regular))
      }
      
      func customFontBold(size: CGFloat) -> some View {
          self.modifier(CustomFontModifier(size: size, weight: .bold))
      }
}
