//
//  CalendarView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift


struct CalendarView: View {
    
    @ObservedResults(MissionData.self)
    var userMissionList
    
    
    @Binding var currentDate: Date
    @State private var currentMonth: Int = 0
    
    private let calendar = Calendar.current
    
    let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State var saying = ""
    
    let list = [
        "이거 할래요!",
        "저거 할래요!",
        "하기 싫어요!"
    ]
    
    var body: some View {
        
            NavigationView {
                
                ZStack {
                    ViewBackground()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        topCalendarView()
                        weekdaysView()
                        daysComponentView(colums: columns)
                        ForEach(userMissionList, id: \.id) { item in
                            MissionListView(userMissionList: item)
                        }
                    }
                }
                .background(Color.clear)
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
            ForEach(getDate()) { item in
                daysView(value: item)
                    .foregroundStyle(isSameDay(date1: item.date, date2: currentDate) ? .pink : .black)
                    .onTapGesture {
                        currentDate = item.date
                    }
            }
        }
    }
    
    func weekdaysView() -> some View {
        HStack {
            ForEach(weekDays, id: \.self) { day in
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
        
        let monthLabel = getDateData(for: getCurrentMonth())
        
        Button(action: {
            currentMonth -= 1
        }, label: {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundStyle(.black)
        })
        Text(monthLabel[1])
            .font(.custom("Menlo-Bold", size: 30))
//            .foregroundStyle(Color(hex: "#57a3ff"))
            .foregroundStyle(.black)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
        Button(action: {
            currentMonth += 1
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

//MARK: about Day components

extension CalendarView {
    
    
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
//        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    func getDateData(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let dateString = formatter.string(from: date)
        return dateString.components(separatedBy: " ")
    }

    
    func getCurrentMonth() -> Date {
        guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
    func getDate() -> [DateValue] {
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return [] }
        
        var days = currentMonth.getDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date )
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

#Preview {
    TabBarView()
}
