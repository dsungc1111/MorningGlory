//
//  MissionListView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import SwiftUI
import RealmSwift

struct MissionListView: View {
    
    @ObservedRealmObject
    var userMissionList: MissionData
    
    @StateObject private var calendarVM = CalendarVM()
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#b782c4"))
                    .frame(height: 70)
                    .padding(.horizontal, 10)
                HStack {
                    Button(action: {
                        calendarVM.action(.missionComplete((userMissionList, 1)))
                    }, label: {
                        Image(systemName: userMissionList.mission1Complete ? "checkmark.square.fill" : "checkmark.square" )
                            .resizable()
                            .frame(width: 40, height: 40)
                            .tint(.white)
                    })
                    .padding(.trailing, 20)
                    VStack(alignment: .leading) {
                        Text(userMissionList.mission1)
                            .font(.title.bold())
                            .padding(.bottom, 2)
                        Text("05:30 ~ 06:30")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 10)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#f7cf76"))
                    .frame(height: 70)
                    .padding(.horizontal, 10)
                HStack {
                    Button(action: {
                        calendarVM.action(.missionComplete((userMissionList, 2)))
                    }, label: {
                        Image(systemName: userMissionList.mission2Complete ? "checkmark.square.fill" : "checkmark.square" )
                            .resizable()
                            .frame(width: 40, height: 40)
                            .tint(.white)
                    })
                    .padding(.trailing, 20)
                    VStack(alignment: .leading) {
                        Text(userMissionList.mission2)
                            .font(.title.bold())
                            .padding(.bottom, 2)
                        Text("06:30 ~ 07:30")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 10)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#52db9b"))
                    .frame(height: 70)
                    .padding(.horizontal, 10)
                HStack {
                    Button(action: {
                        calendarVM.action(.missionComplete((userMissionList, 3)))
                    }, label: {
                        Image(systemName: userMissionList.mission3Complete ? "checkmark.square.fill" : "checkmark.square" )
                            .resizable()
                            .frame(width: 40, height: 40)
                            .tint(.white)
                    })
                    .padding(.trailing, 20)
                    VStack(alignment: .leading) {
                        Text(userMissionList.mission3)
                            .font(.title.bold())
                            .padding(.bottom, 2)
                        Text("07:30 ~ 08:30")
                            .font(.system(size: 14))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 10)
    }
}
