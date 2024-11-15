//
//  MissionCardView.swift
//  MorningGlory
//
//  Created by 최대성 on 11/11/24.
//

import SwiftUI


struct MissionCards: View {
    
    @ObservedObject
    var missionItem: MissionData
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.white)
            .frame(height: 80)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Date.dateToTimeString(from: missionItem.startTime)) ~ \(Date.dateToTimeString(from: missionItem.endTiem))")
                            .customFontBold(size: 16)
                            .padding(.bottom, 10)
                            .foregroundStyle(.gray)
                        
                        Text(missionItem.mission)
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
