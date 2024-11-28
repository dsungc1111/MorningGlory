//
//  AddMissionView.swift
//  MorningGlory
//
//  Created by 최대성 on 11/11/24.
//

import SwiftUI

struct AddMissionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var missionText = ""

    var body: some View {
        mainView()
            .background(Color(hex: "#d7eff9"))
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
                           displayedComponents: [.hourAndMinute])
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
                saveMission()
                presentationMode.wrappedValue.dismiss()
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
    
    private func saveMission() {
        let newMission = Missions(context: viewContext)
        newMission.todayDate = Calendar.current.startOfDay(for: Date())
        newMission.startTime = startTime
        newMission.endTime = endTime
        newMission.mission = missionText
        newMission.missionComplete = false
        
        do {
            try viewContext.save()
            print("✅ 미션 저장 완료!")
        } catch {
            print("❌ 저장 실패: \(error)")
        }
    }
}
