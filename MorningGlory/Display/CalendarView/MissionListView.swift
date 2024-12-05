//
//  MissionListView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import SwiftUI
import CoreData

struct MissionListView: View {
    
    @ObservedObject var mission: Missions // Core Data 객체를 ObservedObject로 감지
    
    var body: some View {
        VStack {
            missionCardView()
        }
        .padding(.horizontal, 10)
    }
    
    private func missionCardView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.pink.opacity(0.5))
                .frame(height: 70)
                .padding(.horizontal, 10)
            HStack {
                Button {
                    mission.missionComplete.toggle() // 상태 변경
                    saveChanges() // Core Data 변경 사항 저장
                } label: {
                    Image(systemName: mission.missionComplete ? "checkmark.square.fill" : "checkmark.square")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .tint(.white)
                        .padding(.trailing, 20)
                }
                
                VStack(alignment: .leading) {
                    Text(mission.mission ?? "No Mission")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 2)
                    
                    Text("\(Date.dateToTimeString(from: mission.startTime ?? Date())) ~ \(Date.dateToTimeString(from: mission.endTime ?? Date()))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 10)
    }
    
    private func saveChanges() {
        guard let context = mission.managedObjectContext else { return }
        do {
            try context.save()
            print("Changes saved successfully.")
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
