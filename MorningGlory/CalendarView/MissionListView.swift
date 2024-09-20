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
            HStack {
                Text(userMissionList.mission1)
                Spacer()
                Button(action: {
                    calendarVM.action(.missionComplete((userMissionList, 1)))
                }, label: {
                    Image(systemName: userMissionList.mission1Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
            
            HStack {
                Text(userMissionList.mission2)
                Spacer()
                Button(action: {
                    calendarVM.action(.missionComplete((userMissionList, 2)))
                }, label: {
                    Image(systemName: userMissionList.mission2Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
            
            HStack {
                Text(userMissionList.mission3)
                Spacer()
                Button(action: {
                    calendarVM.action(.missionComplete((userMissionList, 3)))
                }, label: {
                    Image(systemName: userMissionList.mission3Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
            
        }
        .padding(.horizontal, 30)
    }
}
