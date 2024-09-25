//
//  UserInfoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift

struct UserInfoView: View {
    
    let totalDays = 30
    
    @State private var value = 0.0
    
    let totalDuration: Double = 60
    
    @ObservedResults(MissionData.self)
    var missionList
    
    
    var body: some View {
            
            ScrollView {
                VStack {
                    
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .fill(.gray)
                        .frame(height: 100)
                        .padding(.horizontal, 20)
                    circleGrapth()
                    
                }
            }
            .background(Color(hex: "#d7eff9"))
        
    }
    
    func circleGrapth() -> some View {
        
        ZStack {
            
            Circle()
                .stroke(lineWidth: 30)
                .frame(width: 200, height: 200)
                .foregroundStyle(Color(hex: "#d7eff9"))
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 10, y: 10)
            Circle()
                .stroke(lineWidth: 0.34)
                .frame(width: 175, height: 175)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .clear]), startPoint: .bottomTrailing, endPoint: .topLeading))
            
            Circle()
                .trim(from: 0, to: value)
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text(String(format: "%.1f", value/30*1000) + "%")
                .customFontBold(size: 20)
            
        }
        .onAppear() {
            for item in missionList {
                if item.success {
                    value += 0.1
                }
            }
            print("value 값", value)
        }
    }

    
}

#Preview {
    UserInfoView()
}
