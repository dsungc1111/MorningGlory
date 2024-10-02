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
    
    @StateObject private var calendarVM = CalendarVM(missionRepo: RealmRepository())
    
    var body: some View {
        VStack {
            mission1View()
            mission2View()
            mission3View()
        }
        .padding(.horizontal, 10)
    }
    
    private func mission1View() -> some View  {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(PostItColor.pink.background)
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
                        .customFontBold(size: 20)
                        .padding(.bottom, 2)
                    Text("05:30 ~ 06:30")
                        .customFontRegular(size: 14)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 10)
    }
    
    private func mission2View() -> some View  {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(PostItColor.yellow.background)
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
                        .customFontBold(size: 20)
                        .padding(.bottom, 2)
                    Text("06:30 ~ 07:30")
                        .customFontRegular(size: 14)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 10)
    }
    
    private func mission3View() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(PostItColor.green.background)
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
                        .customFontBold(size: 20)
                        .padding(.bottom, 2)
                    Text("07:30 ~ 08:30")
                        .customFontRegular(size: 14)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 10)
    }
}
