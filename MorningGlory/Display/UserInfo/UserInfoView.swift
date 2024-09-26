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
    
    @State private var successCount = 0
    @State private var failCount = 0
    @State private var percentage = 0.0
    @State private var fail = 0
    
    private let realmRepo = RealmRepository()
    
    let totalDuration: Double = 60
    
//    
//    @ObservedResults(MissionData.self)
//    var missionList
    
    var body: some View {
        
        
        NavigationView {
            mainView()
                .background(Color(hex: "#d7eff9"))
        }
    }
    
    func mainView() -> some View {
        ScrollView {
            statisticsView()
                .padding(.bottom, 50)
            countView()
        }
    }
    
    
    func countView() -> some View {
        HStack {
            Spacer()
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "#5873f5").opacity(0.5))
                    .frame(height: 180)
                VStack(alignment: .leading) {
                    
                    Text("성공")
                        .customFontBold(size: 24)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    HStack {
                        Spacer()
                        Text("\(successCount)")
                            .customFontBold(size: 80)
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Text("회")
                            .customFontBold(size: 20)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                }
            }
            Spacer()
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "#5873f5").opacity(0.5))
                    .frame(height: 180)
                VStack(alignment: .leading) {
                    
                    Text("실패")
                        .customFontBold(size: 24)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    HStack {
                        Spacer()
                        Text("\(failCount)")
                            .customFontBold(size: 80)
                            .foregroundStyle(.white)
                            .padding(.leading, 10)
                        Text("회")
                            .customFontBold(size: 20)
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    
                }
                
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    
    func statisticsView() -> some View {
        
        VStack {
            Text("30일 챌린지")
                .customFontBold(size: 40)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading, 30)
            graphView()
        }
        .offset(y:30)
    }
    
    
    func graphView() -> some View {
        VStack {
            
            Text("*\(successCount)일째 진행 중")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .customFontRegular(size: 20)
                .foregroundStyle(.blue)
            
            
            circleGrapth()
                .padding(.top, 30)
                .navigationTitle("User")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.bottom, 30)
            
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity)
    }
    
    func circleGrapth() -> some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 30)
                .frame(width: 200, height: 200)
                .foregroundStyle(Color(hex: "#d7eff9"))
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Circle()
                .stroke(lineWidth: 0.34)
                .frame(width: 175, height: 175)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .clear]), startPoint: .bottomTrailing, endPoint: .topLeading))
            
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text(String(format: "%.1f", percentage*100) + "%")
                .customFontBold(size: 24)
        }
        .onAppear() {
            checkSuccess()
        }
    }
    
    private func checkSuccess() {
       
        successCount = realmRepo.countSuccess()
        successCount = successCount >= 30 ? 30 : successCount
        percentage = Double(successCount) / Double(totalDays)
        failCount = realmRepo.countFail()
        
        
        print("value 값", successCount, failCount)
    }
}

#Preview {
    UserInfoView()
}
