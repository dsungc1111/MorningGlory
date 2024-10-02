//
//  ToDoVM.swift
//  MorningGlory
//
//  Created by 최대성 on 9/19/24.
//

import Foundation
import Combine


final class ToDoVM: ViewModelType {
    
    var cancellables = Set<AnyCancellable>()
    
    private var locationManager = LocationManager()
    
    private var missionRepo: DatabaseRepository
    //    private let realmRepo = RealmRepository()
    
    struct Input {
        let getWeather = PassthroughSubject<Void, Never>()
        let saveMission = PassthroughSubject<Void, Never>()
        let saveWakeUpTime = PassthroughSubject<Date, Never>()
    }
    
    struct Output {
        var mission1 = ""
        var mission2 = ""
        var mission3 = ""
        var toast: Toast? = nil
        var weatherIcon: String = ""
        var weatherText = ""
        var temperature: Double = 0.0
        var wakeupTime = Date()
        
        var filteredMissionList: [MissionData] = []
        var allMissionList: [MissionData] = []
    }
    
    var areAllMissionsFilled: Bool {
        return !output.mission1.isEmpty && !output.mission2.isEmpty && !output.mission3.isEmpty
    }
    
    var input = Input()
    
    @Published
    var output = Output()
    
    init(missionRepo: DatabaseRepository) {
        self.missionRepo = missionRepo
        transform()
        let date = Date()
        output.filteredMissionList = missionRepo.getFetchedMissionList(todayDate: date)
        output.allMissionList = missionRepo.fetchData(of: MissionData.self) ?? []
        //        missionRepo.fetchURL()
    }
    
}


extension ToDoVM {
    
    enum Action {
        case weather
        case mission
        case wakeUpTime(Date)
    }
    
    
    func action(_ action: Action) {
        
        switch action {
        case .weather:
            input.getWeather.send(())
        case .mission:
            input.saveMission.send(())
        case .wakeUpTime(let date):
            input.saveWakeUpTime.send(date)
        }
        
    }
    
    func transform() {
        
        input.getWeather
            .sink { [weak self] _ in
                guard let self else { return }
                self.fetchWeather()
            }
            .store(in: &cancellables)
        
        input.saveMission
            .sink { [weak self] _ in
                guard let self else { return }
                self.saveMission()
            }
            .store(in: &cancellables)
        input.saveWakeUpTime
            .sink { [weak self] time in
                guard let self else { return }
                self.saveWakeUpTime(time: time)
            }
            .store(in: &cancellables)
    }
    
    
}

//MARK: - About Weather & Saying

extension ToDoVM {
    
    func saveInfo() {
        print(#function)
        RandomFamousSaying.shared.getSaying { result in
            switch result {
            case .success(let success):
                UserDefaultsManager.saying = success.message
                UserDefaultsManager.dayDate = Date()
            case .failure(_):
                UserDefaultsManager.saying = "다시 도전"
            }
        }
    }
    
    func fetchWeather() {
        
        if shouldFetchNewSaying() {
            saveInfo()
        }
        if let location = locationManager.location {
            GetWeather.shared.callWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { [weak self] result in
                guard let self else { return }
                output.weatherIcon = result.weather.first?.icon ?? "아이콘"
                output.temperature = result.main.temp
                output.weatherText = result.weather.first?.main ?? ""
            }
        }
    }
    
    
    func shouldFetchNewSaying() -> Bool {
        print(#function)
        let lastFetchDate = UserDefaultsManager.dayDate
        let calendar = Calendar.current
        if let daysBetween = calendar.dateComponents([.day], from: lastFetchDate, to: Date()).day, daysBetween >= 1 {
            return true
        } else if UserDefaultsManager.saying == "" {
            return true
        } else {
            return false
        }
    }
    
}

//MARK: - About Mission

extension ToDoVM {
    
    
    func saveMission() {
        
        let date = Date()
        
        let todayDate = Date.todayDate(from: date)
        
        
        let newMission = MissionData(
            todayDate: todayDate,
            wakeUpTime: output.wakeupTime,
            mission1: output.mission1,
            mission2: output.mission2,
            mission3: output.mission3
        )
        missionRepo.saveOrUpdateMission(todayDate: todayDate, missionData: newMission)
        
        // 전체 리스트 업데이트
        output.allMissionList = missionRepo.fetchData(of: MissionData.self) ?? []
        
        // 사용자 피드백
        if output.allMissionList.contains(where: { $0.todayDate == todayDate }) {
            output.toast = Toast(type: .edit, title: "수정완료 🌞🌞", message: "미션을 수정했어요!", duration: 3.0)
        } else {
            output.toast = Toast(type: .success, title: "등록완료 🌞🌞", message: "미션을 등록했어요!", duration: 3.0)
        }
    }
    
    
    func saveWakeUpTime(time: Date) {
        
        output.wakeupTime = Date.getWakeUpTime(from: time)
        print("기상 시간 저장", output.wakeupTime)
    }
    
    
    
}
