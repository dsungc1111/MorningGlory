//
//  CalendarVM.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import Foundation
import Combine

final class CalendarVM: ViewModelType {
    
    struct Input {
        let changeDate = PassthroughSubject<Date, Never>()
        let missionComplete = PassthroughSubject<(MissionData, Int), Never>()
    }
    
    struct Output {
        
        var currentDate: Date = Date()
        var currentMonth: Int = 0
        
        let calendar = Calendar.current
        
        let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var saying = ""
        var filteredMissionList: [MissionData] = []
        var allMissionList: [MissionData] = []
        var missionSuccess = false
    }
    
    private let realmRepo = RealmRepository()
    
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    
    
    @Published
    var output = Output()
    
    enum Action {
        case changeDate(Date)
        case missionComplete((MissionData, Int))
    }
    
    
    init() {
        transform()
        output.allMissionList = realmRepo.getAllMissionList()
    }
    
    func transform() {
        input.changeDate
            .sink { [weak self] date in
                guard let self else { return }
                output.currentDate = date
                filteredMissions()
            }
            .store(in: &cancellables)
        
        input.missionComplete
            .sink { [weak self] (data, index) in
                guard let self else { return }
                missionComplete(missionData: data, index: index)
            }
            .store(in: &cancellables)
    }

    func missionComplete(missionData: MissionData, index: Int) {
        
        if let mission = missionData.thaw() {
            try? mission.realm?.write {
                switch index {
                case 1:
                    mission.mission1Complete.toggle()
                case 2:
                    mission.mission2Complete.toggle()
                case 3:
                    mission.mission3Complete.toggle()
                default:
                    break
                }
                if mission.mission1Complete && mission.mission2Complete && mission.mission3Complete {
                    mission.success = true
                } else {
                    mission.success = false
                }
                output.missionSuccess = mission.success
            }
        }
    }
    
    
    func action(_ action: Action) {
        
        switch action {
        case .changeDate(let selectedDate):
            input.changeDate.send(selectedDate)
        case .missionComplete((let mission, let isComplete)):
            input.missionComplete.send((mission, isComplete))
        }
    }
    
    func filteredMissions() {
        output.filteredMissionList = realmRepo.getFetchedMissionList(todayDate: output.currentDate)
        print("🔫🔫🔫🔫🔫🔫리스트 필터됨",output.filteredMissionList)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return output.calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    func getDateData(for date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
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
