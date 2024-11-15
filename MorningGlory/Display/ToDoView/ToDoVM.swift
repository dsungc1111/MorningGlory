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
    
    private var missionRepo: DatabaseRepository
    
    struct Input {
        let getWeather = PassthroughSubject<Void, Never>()
        let saveMission = PassthroughSubject<Void, Never>()
        let saveWakeUpTime = PassthroughSubject<Date, Never>()
    }
    
    struct Output {
        
        var mission2 = ""
        var mission3 = ""
        
        
        var mission = ""
        var toast: Toast? = nil
        var weatherIcon: String = ""
        var weatherText = ""
        var temperature: Double = 0.0
        var wakeupTime = Date()
        var missionComplete = false
        var startTime = Date()
        var endTime = Date()
        
        var filteredMissionList: [MissionData] = [] // 오늘날짜만
        var allMissionList: [MissionData] = [] // 미션 전체
    }
    
    var input = Input()
    
    @Published
    var output = Output()
    
    init(missionRepo: DatabaseRepository) {
        self.missionRepo = missionRepo
        transform()
        let date = Date()
        output.filteredMissionList = missionRepo.getFetchedMissionList(todayDate: date)
        output.allMissionList = missionRepo.fetchData(of: MissionData.self)
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
        
        let saying = RandomFamousSaying()
        
        saying.getSaying { result in
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
            Task {
                let weatherService = GetWeather()
                let result = try await weatherService.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    output.weatherIcon = result.weather.first?.icon ?? ""
                    output.temperature = result.main.temp
                    output.weatherText = result.weather.first?.main ?? ""
                }
                
            }
        }
    }
    
    
    func shouldFetchNewSaying() -> Bool {
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
            mission: output.mission,
            missionComplete: output.missionComplete,
            startTime: output.startTime,
            endTime: output.endTime
        )
        
        // 전체 리스트 업데이트
        output.allMissionList = missionRepo.fetchData(of: MissionData.self)
        
        // 사용자 피드백
        // 해당 날짜에 컨텐츠가 있는지 없는지
        if let existingDateList = missionRepo.fetchDateList(for: todayDate) {
             // 기존 DateList에 새 미션 추가
            print("😈😈😈😈😈😈😈 DateList 이미 있음!!")
             try! existingDateList.realm?.write {
                 existingDateList.mission.append(newMission)
             }
//             output.toast = Toast(type: .edit, title: "수정완료 🌞🌞", message: "미션을 수정했어요!", duration: 3.0)
         } else {
             // 새로운 DateList 생성 및 미션 추가
             print("🔫🔫🔫🔫🔫🔫🔫 DateList 없어서 새로 추가!!")
             let newDateList = DateList(mission: List<MissionData>(), today: todayDate)
             newDateList.mission.append(newMission)
             
             missionRepo.save(newDateList)
//             output.toast = Toast(type: .success, title: "등록완료 🌞🌞", message: "미션을 등록했어요!", duration: 3.0)
         }
        missionRepo.saveOrUpdateMission(todayDate: todayDate, missionData: newMission)
        output.filteredMissionList = missionRepo.getFetchedMissionList(todayDate: todayDate)
        print("🔫🔫🔫🔫🔫🔫🔫 오늘 미션 개수", output.filteredMissionList.count)
    }
    
    // date 포맷 바꿔서 저장
    func saveWakeUpTime(time: Date) {
        output.wakeupTime = Date.getWakeUpTime(from: time)
    }
    
}
