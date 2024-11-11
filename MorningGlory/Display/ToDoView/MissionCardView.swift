//
//  MissionCardView.swift
//  MorningGlory
//
//  Created by 최대성 on 11/11/24.
//

import SwiftUI


struct MissionCards: View {
    var time: String
    
    @Binding var mission: String
    
    var backgroundColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(backgroundColor)
            .frame(height: 80)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("05:20 ~ 06:40")
                            .customFontBold(size: 16)
                            .padding(.bottom, 10)
                            .foregroundStyle(.gray)
                        
                        Text("여기에 미션이 들어갈거임")
                            .customFontBold(size: 20)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
            )
            .padding(.horizontal, 20)
    }
}
