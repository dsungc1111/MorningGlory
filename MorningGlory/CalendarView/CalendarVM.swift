//
//  CalendarVM.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import Foundation
import Combine
import RealmSwift

final class CalendarVM: ViewModelType {
    
    struct Input {
        let chageDate = PassthroughSubject<Date, Never>()
    }
    
    struct Output {
        @ObservedResults(MissionData.self)
        var userMissionList
        
        
        var currentDate: Date = Date()
        var currentMonth: Int = 0
        
        let calendar = Calendar.current
        
        let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var saying = ""
        var filteredMissionList: [MissionData] = []
    }
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    
    @Published
    var output = Output()
    
    enum Action {
        case changeDate(Date)
    }
    
    
    init() {
        transform()
    }
    
    func transform() {
        input.chageDate
            .sink { [weak self] date in
                guard let self else { return }
                output.currentDate = date
                filteredMissions()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        
        switch action {
        case .changeDate(let selectedDate):
            input.chageDate.send(selectedDate)
        }
    }
    
    func filteredMissions() {
        output.filteredMissionList = output.userMissionList.filter { mission in
            isSameDay(date1: mission.todayDate, date2: output.currentDate)
        }
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return output.calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    func getDateData(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let dateString = formatter.string(from: date)
        return dateString.components(separatedBy: " ")
    }
    
    
    func getCurrentMonth() -> Date {
        guard let currentMonth = output.calendar.date(byAdding: .month, value: output.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    
    func getDate() -> [DateValue] {
        
        guard let currentMonth = output.calendar.date(byAdding: .month, value: output.currentMonth, to: Date()) else { return [] }
        
        var days = currentMonth.getDates().compactMap { date -> DateValue in
            let day = output.calendar.component(.day, from: date )
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = output.calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
}
