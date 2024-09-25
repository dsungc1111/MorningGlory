//
//  TextFieldView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/24/24.
//

import SwiftUI


struct TextWritingView: View {
    @State private var height: CGFloat = 30
    @Binding var text: String
 
    var body: some View {
        
        HStack(alignment: .bottom, spacing: 10) {
            
            CustomTextView(
                text: $text,
                height: $height,
                maxHeight: 220,
                cornerRadius: 5,
                borderWidth: 1,
                borderColor: CGColor.init(red: 255, green: 255, blue: 255, alpha: 1),
                placeholder: "댓글을 입력해 주세요"
            )
            .frame(minHeight: height, maxHeight: .infinity)
         
        }
        .padding(.all, 10)
        .frame(height: 50)
        .frame(minHeight: height + 20)
        
        Text("\(text.count) / 300")
            .foregroundColor(Color(UIColor.lightGray))
            .padding(.leading, 15)
    }
}
