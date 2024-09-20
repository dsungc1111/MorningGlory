//
//  CalendarView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift


struct CalendarView: View {
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @ObservedResults(MissionData.self)
    var userMissionList
    
    @StateObject private var calendarVM = CalendarVM()
    
    var body: some View {
        mainView()
    }
    
    func mainView() -> some View {
        NavigationView {
            ZStack {
                ViewBackground()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        topCalendarView()
                        weekdaysView()
                        daysComponentView(colums: columns)
                        ForEach(calendarVM.output.filteredMissionList, id: \.id) { item in
                            MissionListView(userMissionList: item)
                        }
                    }
                }
                .onAppear {
                    calendarVM.action(.changeDate(Date()))
                }
                .background(Color.clear)
                //                    Image("file")
                //                        .resizable()
                //                        .frame(width: 80, height: 80)
                //                        .shadow(color: .orange, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                //                        .offset(x: 100, y: 200)
            }
            
        }
    }
}

struct MissionListView: View {
    
    @ObservedRealmObject
    var userMissionList: MissionData
    
    var body: some View {
        VStack {
            HStack {
                Text(userMissionList.mission1)
                Spacer()
                Button(action: {
                    print("토글됨")
                    $userMissionList.mission1Complete.wrappedValue.toggle()
                }, label: {
                    Image(systemName: userMissionList.mission1Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
           
            HStack {
                Text(userMissionList.mission2)
                Spacer()
                Button(action: {
                    print("토글됨")
                    $userMissionList.mission2Complete.wrappedValue.toggle()
                }, label: {
                    Image(systemName: userMissionList.mission2Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
            
            HStack {
                Text(userMissionList.mission3)
                Spacer()
                Button(action: {
                    print("토글됨")
                    $userMissionList.mission3Complete.wrappedValue.toggle()
                }, label: {
                    Image(systemName: userMissionList.mission3Complete ? "checkmark.square.fill" : "checkmark.square" )
                })
            }
            
        }
        .padding(.horizontal, 30)
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
                    .font(.custom("Menlo-Bold", size: 16))
                    .fontWeight(.semibold)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(day == "Sun" ? .red : .black)
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
            .font(.custom("Menlo-Bold", size: 30))
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
                    .font(.title3.bold())
                //                Image("file")
                //                    .resizable()
                //                    .frame(width: 50, height: 50)
                //                    .background(.clear)
            }
        }
        .frame(height: 100, alignment: .top)
    }
}

#Preview {
    TabBarView()
}
