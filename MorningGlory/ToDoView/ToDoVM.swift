//
//  ToDoVM.swift
//  MorningGlory
//
//  Created by 최대성 on 9/19/24.
//

import Foundation
import Combine
import RealmSwift


final class ToDoVM: ViewModelType {
    
    var cancellables = Set<AnyCancellable>()
    private var locationManager = LocationManager()
    
    struct Input {
        let getWeather = PassthroughSubject<Void, Never>()
        let saveMission = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var mission1 = ""
        var mission2 = ""
        var mission3 = ""
        var toast: Toast? = nil
        var weatherIcon: String = ""
        var temperature: Double = 0.0
        
        @ObservedResults(MissionData.self)
        var userMissionList
    }
    
    
    
    var areAllMissionsFilled: Bool {
        return !output.mission1.isEmpty && !output.mission2.isEmpty && !output.mission3.isEmpty
    }
    
    var input = Input()
    
    @Published
    var output = Output()
    
    init() {
        transform()
    }
    
}


extension ToDoVM {
    
    enum Action {
        case weather
        case mission
    }
    
    
    
    func action(_ action: Action) {
        print(#function)
        switch action {
        case .weather:
            input.getWeather.send(())
        case .mission:
            input.saveMission.send(())
        }
    }
    
    func transform() {
        print(#function)
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
        
        print(#function)
        if shouldFetchNewSaying() {
            saveInfo()
        }
        if let location = locationManager.location {
            GetWeather.shared.callWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { [weak self] result in
                guard let self else { return }
                output.weatherIcon = result.weather.first?.icon ?? "아이콘"
                output.temperature = result.main.temp
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
        // saveMission
        let date = Date()
        
        let todayDate = Date.todayDate(from: date)
        let wakeuptime = Date.getWakeUpTime(from: date)
        
        if let existingMission = output.userMissionList.first(where: { $0.todayDate == todayDate }) {
            
            if let editMission = existingMission.thaw() {
                try? editMission.realm?.write {
                    editMission.wakeUpTime = wakeuptime
                    editMission.mission1 = output.mission1
                    editMission.mission2 = output.mission2
                    editMission.mission3 = output.mission3
                    print("🔫🔫🔫🔫데이터 수정 완료: ", editMission)
                }
            }
            print("🔫🔫🔫🔫데이터 수정 완료: ", output.userMissionList)
            output.toast = Toast(type: .edit, title: "수정완료 🌞🌞", message: "미션을 수정했어요!", duration: 3.0)
        } else {
            
            let newMission = MissionData(todayDate: todayDate, wakeUpTime: wakeuptime, mission1:output.mission1, mission2: output.mission2, mission3: output.mission3)
            output.$userMissionList.append(newMission)
            print("🔫🔫🔫🔫새 데이터 추가 완료: ", newMission)
            output.toast = Toast(type: .success, title: "등록완료 🌞🌞", message: "미션을 등록했어요!", duration: 3.0)
        }
    }
}
