//
//  AddMissionView.swift
//  MorningGlory
//
//  Created by 최대성 on 11/11/24.
//

import SwiftUI


struct AddMissionView: View {
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var missionText = ""
    
    var body: some View {
//        NavigationView {
            mainView()
//                .navigationTitle("미션 추가").customFontBold(size: 20)
//                .navigationBarTitleDisplayMode(.inline)
                .background(Color(hex: "#d7eff9"))
//        }
//        .background(Color(hex: "#d7eff9"))
    }
    
    private func mainView() -> some View {
        VStack {
            Text("미션 추가")
                .padding(.top, 30)
                .padding(.bottom, 20)
                .customFontBold(size: 24)
            
            VStack {
                DatePicker("시작 시간",
                           selection: $startTime,
                           displayedComponents: [.hourAndMinute]
                )
                DatePicker("종료 시간",
                           selection: $endTime,
                           displayedComponents: [.hourAndMinute])
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
            
            Text("미션 입력")
                .frame(maxWidth: .infinity, alignment: .leading)
                .customFontBold(size: 20)
                .padding(.bottom, 10)
            
            TextField("미션을 입력하세요", text: $missionText)
                .padding(.bottom, 40)
            
            Button {
                print("저장저장")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(missionText.isEmpty ? .gray : .white)
                        .padding(.horizontal, 50)
                        .frame(height: 40)
                    Text("미션 저장")
                        .foregroundStyle(missionText.isEmpty ? .white : .black)
                }
            }
            .disabled(missionText.isEmpty)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
