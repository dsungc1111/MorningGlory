//
//  CalendarView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

//struct CalendarView: View {
//    var body: some View {
//        Text("캘린더뷰")
//
//    }
//}
//

struct BoxView: View {
    @State var date = Date()
    var body: some View {
        CalendarView(currentDate: $date)
    }
}

struct CalendarView: View {
    @Binding var currentDate: Date
    @State private var currentMonth: Int = 0
    
    let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        
        VStack(spacing: 20) {
            topCalendarView()
            weekdaysView()
            daysComponentView(colums: columns)
        }
    }
}
//MARK: about View
extension CalendarView {
    
    func topCalendarView() -> some View {
        HStack(spacing: 20) {
            dayInfo()
            Spacer()
//            buttonForChangeView()
        }
        .padding()
    }
    
    
    func daysComponentView(colums: [GridItem]) -> some View {
        
        LazyVGrid(columns: colums) {
            ForEach(getDate()) { item in
                daysView(value: item)
                    .foregroundStyle(isSameDay(date1: item.date, date2: currentDate) ? .pink : Color(hex: "#57a3ff"))
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
    func buttonForChangeView() -> some View {
        Button(action: {
            currentMonth -= 1
        }, label: {
            Image(systemName: "chevron.left")
                .font(.title2)
        })
        Button(action: {
            currentMonth += 1
        }, label: {
            Image(systemName: "chevron.right")
                .font(.title2)
        })
    }
    
    @ViewBuilder
    func dayInfo() -> some View {
        
        let monthLabel = getDateData(for: getCurrentMonth())
        
//        VStack(alignment: .leading, spacing: 10) {
            Text(monthLabel[1])
                .font(.custom("Menlo-Bold", size: 30))
                .foregroundStyle(Color(hex: "#57a3ff"))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
//        }
    }
    
    
    func daysView(value: DateValue) -> some View {
        
        VStack {
            if value.day != -1 {
                Text("\(value.day)")
                    .font(.title3.bold())
            }
        }
//        .padding(.vertical, 8)
        .frame(height: 100, alignment: .top)
    }
}

//MARK: about Day components

extension CalendarView {
    
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
    
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    func getDateData(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let dateString = formatter.string(from: date)
        return dateString.components(separatedBy: " ")
    }

    
    func getCurrentMonth() -> Date {
        guard let currentMonth = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
    func getDate() -> [DateValue] {
        
        guard let currentMonth = Calendar.current.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return [] }
        
        var days = currentMonth.getDates().compactMap { date -> DateValue in
            let day = Calendar.current.component(.day, from: date )
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = Calendar.current.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}


extension Date {
    
    func getDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}





#Preview {
    BoxView()
}
