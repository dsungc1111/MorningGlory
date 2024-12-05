//
//  CalendarView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift

import SwiftUI
import CoreData

struct CalendarView: View {
    
    @FetchRequest(
        entity: Missions.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Missions.startTime, ascending: true)],
        predicate: NSPredicate(format: "todayDate == %@", Calendar.current.startOfDay(for: Date()) as NSDate)
    ) var missions: FetchedResults<Missions>
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @ObservedResults(MissionData.self) // Realm 데이터 감지
    private var userMissionList
    
    @StateObject private var calendarVM = CalendarVM(missionRepo: RealmRepository())
    
    var body: some View {
        mainView()
    }
    
    func mainView() -> some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    topCalendarView()
                    weekdaysView()
                    daysComponentView(colums: columns)
                    
                    // Core Data 미션 리스트
                    ForEach(missions, id: \.self) { mission in
                        MissionListView(mission: mission)
                    }
                }
            }
            .padding(.top, 10)
            .onAppear {
                calendarVM.action(.changeDate(Date()))
                print("필터된 Realm 데이터: \(calendarVM.output.filteredMissionList)")
                print("Realm 파일 위치: \(Realm.Configuration.defaultConfiguration.fileURL ?? URL(fileURLWithPath: ""))")
            }
            .background(Color(hex: "#d7eff9"))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



//MARK: about View
extension CalendarView {
    
    func topCalendarView() -> some View {
        HStack(spacing: 20) {
            dayInfo()
        }
        .padding()
    }
    
    func daysComponentView(colums: [GridItem]) -> some View {
        
        LazyVGrid(columns: colums) {
            ForEach(calendarVM.getDate()) { item in
                daysView(value: item)
                    .foregroundStyle(calendarVM.isSameDay(date1: item.date, date2: calendarVM.output.currentDate) ? .pink : .black)
                    .onTapGesture {
                        calendarVM.action(.changeDate(item.date))
                    }
            }
        }
    }
    
    func weekdaysView() -> some View {
        HStack {
            ForEach(calendarVM.output.weekDays, id: \.self) { day in
                Text(day)
                    .customFontBold(size: 16)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
            }
        }
    }
    
    @ViewBuilder
    func dayInfo() -> some View {
        
        let monthLabel = calendarVM.getDateData(for: calendarVM.getCurrentMonth())
        
        Button(action: {
            calendarVM.output.currentMonth -= 1
        }, label: {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundStyle(.black)
        })
        Text(monthLabel[1])
            .customFontBold(size: 30)
            .foregroundStyle(.black)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        Button(action: {
            calendarVM.output.currentMonth += 1
        }, label: {
            Image(systemName: "chevron.right")
                .font(.title2)
                .foregroundStyle(.black)
        })
    }
    
    
    func daysView(value: DateValue) -> some View {
        
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(calendarVM.isSameDay(date1: value.date, date2: calendarVM.output.currentDate) ? .custom("HakgyoansimDunggeunmisoOTF-B", size: 20) : .custom("HakgyoansimDunggeunmisoOTF-R", size: 20))
                    .padding(.bottom, 10)
                if let mission = userMissionList.first(where: { mission in
                    calendarVM.isSameDay(date1: mission.todayDate, date2: value.date)
                }) {
                    Image(systemName: mission.missionComplete ? "star.fill" : "")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(mission.missionComplete ? Color(hex: "#b69a51") : .gray)
                }
            }
        }
        .frame(height: 80, alignment: .top)
    }
}

#Preview {
    TabBarView()
}
