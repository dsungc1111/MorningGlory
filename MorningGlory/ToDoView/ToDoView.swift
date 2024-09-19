//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift
import Toast


struct ToDoView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @ObservedResults(MissionData.self)
    var userMissionList
    
    @State private var mission1 = ""
    @State private var mission2 = ""
    @State private var mission3 = ""
    @State private var toast: Toast? = nil
    
    @State private var weatherIcon: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        mainView()
            .toastView(toast: $toast)
    }
    
    
    func mainView() -> some View {
        NavigationView {
            KeyBoardManager().frame(width: 0, height: 0)
            ZStack {
                ViewBackground()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            buttonView()
                            
                        }
                    }
                VStack {
                    sayingView()
                    missionList()
                }
                .offset(y: -10)
            }
            .navigationBarBackButtonHidden(true)
            
            Spacer()
        }
        //        .onAppear {
        //            print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        //        }
    }
    
}

//MARK: - about View
extension ToDoView {
    
    func missionList() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#C8CAFC"))
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .shadow(radius: 5)
                Text("05:00 기상")
                    .font(.system(size: 24).bold())
                    .offset(x: -120)
                    .padding(.leading, 20)
            }
            postItView(backGround: PostItColor.pink.background, fold: PostItColor.pink.foldColor, time: PostItColor.pink.time, textfield: $mission1)
            
            
            postItView(backGround: PostItColor.yellow.background, fold: PostItColor.yellow.foldColor, time: PostItColor.yellow.time, textfield: $mission2)
            
            
            postItView(backGround: PostItColor.orange.background, fold: PostItColor.orange.foldColor, time: PostItColor.orange.time, textfield: $mission3)
            Spacer()
        }
    }
    
    func postItView(backGround: String, fold: String, time: String, textfield: Binding<String>) -> some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color(hex: backGround))
                    .frame(height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(time)
                        .font(.system(size: 24).bold())
                        .padding(.top, 10)
                    TextField("미션을 입력하세요", text: textfield)
                        .font(.title2)
                }
                .padding(.leading, 10)
            }
            .padding(.top, 10)
            .padding(.horizontal, 20)
            FoldedCornerShape()
                .fill(Color(hex: fold))
                .frame(width: 50, height: 50)
                .padding(.trailing, 20)
        }
        
    }
    
}
//MARK: - about logic
extension ToDoView {
    
    func saveInfo() {
        
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
    
    func sayingView() -> some View {
        HStack {
            VStack {
                if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                    AsyncImage(url: iconURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            
                            image.resizable()
                                .frame(width: 70, height: 70)
                                .onAppear {
                                    if let uiImage = image.asUIImage() {
                                        let imageData = uiImage.pngData()
                                        UserDefaultsManager.weather = imageData
                                        print("이미지 저장 성공")
                                        UserDefaults.standard.synchronize()
                                    }
                                }
                        case .failure:
                            Image(systemName: "sun.max.circle")
                                .resizable()
                                .frame(width: 70, height: 70)
                        @unknown default:
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                    }
                    .frame(width: 70, height: 70)
                    
                }
                Text( String(format: "%.1f", temperature)  + "℃")
            }
            Text(UserDefaultsManager.saying)
                .foregroundColor(.black)
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .task {
            //               print("명언", UserDefaultsManager.saying)
            //               print("시간", UserDefaultsManager.dayDate)
            //               print("과연", shouldFetchNewSaying())
            if shouldFetchNewSaying() {
                saveInfo()
            }
            if let location = locationManager.location {
                GetWeather.shared.callWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
                    self.weatherIcon = result.weather.first?.icon ?? "아이콘"
                    self.temperature = result.main.temp
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
    
    func buttonView() -> some View {
        Button {
            let date = Date()
            
            let todayDate = Date.todayDate(from: date)
            let wakeuptime = Date.getWakeUpTime(from: date)
            
            let mission = MissionData(todayDate: todayDate, wakeUpTime: wakeuptime, mission1: mission1, mission2: mission2, mission3: mission3)
            
            if let existingMission = userMissionList.first(where: { $0.todayDate == todayDate }) {
                
                
                if let editMission = existingMission.thaw() {
                    try? editMission.realm?.write {
                        editMission.wakeUpTime = wakeuptime
                        editMission.mission1 = mission1
                        editMission.mission2 = mission2
                        editMission.mission3 = mission3
                        print("🔫🔫🔫🔫데이터 수정 완료: ", editMission)
                    }
                }
                print("🔫🔫🔫🔫데이터 수정 완료: ", userMissionList)
                toast = Toast(type: .edit, title: "수정완료 🌞🌞", message: "미션을 수정했어요!", duration: 3.0)
            } else {
                
                let newMission = MissionData(todayDate: todayDate, wakeUpTime: wakeuptime, mission1: mission1, mission2: mission2, mission3: mission3)
                $userMissionList.append(newMission)
                print("🔫🔫🔫🔫새 데이터 추가 완료: ", newMission)
                toast = Toast(type: .success, title: "등록완료 🌞🌞", message: "미션을 등록했어요!", duration: 3.0)
            }
        } label: {
            Image((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? "file" : "")
                .resizable()
                .frame(width: 40, height: 40)
            Text("저장")
                .font(.system(size: 24).bold())
                .foregroundStyle((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? .blue : .gray)
        }
        .disabled(!(!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty))
    }
    
}


#Preview {
    TabBarView()
}

