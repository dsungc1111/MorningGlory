//
//  MissionListView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct MissionListView: View {
    var mission: Missions // Core Data에서 가져온 개별 Mission 객체
    
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
                Image(systemName: mission.missionComplete ? "checkmark.square.fill" : "checkmark.square")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .tint(.white)
                    .padding(.trailing, 20)
                
                VStack(alignment: .leading) {
                    Text(mission.mission ?? "No Mission")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 2)
                    
                    Text("\( Date.dateToTimeString(from: mission.startTime ?? Date())) ~ \(Date.dateToTimeString(from: mission.endTime ?? Date()))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 10)
    }
}
