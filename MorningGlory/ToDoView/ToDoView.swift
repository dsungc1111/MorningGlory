//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import RealmSwift

final class MissionData: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todayDate: Date
    @Persisted var wakeUpTime: Date
    @Persisted var mission1: String
    @Persisted var mission2: String
    @Persisted var mission3: String
    @Persisted var mission1Complete: Bool
    @Persisted var mission2Complete: Bool
    @Persisted var mission3Complete: Bool
    @Persisted var success: Bool
    
    convenience init(todayDate: Date, wakeUpTime: Date, mission1: String, mission2: String, mission3: String, mission1Complete: Bool = false, mission2Complete: Bool = false, mission3Complete: Bool = false, success: Bool = false) {
        self.init()
        self.todayDate = todayDate
        self.wakeUpTime = wakeUpTime
        self.mission1 = mission1
        self.mission2 = mission2
        self.mission3 = mission3
        self.mission1Complete = mission1Complete
        self.mission2Complete = mission2Complete
        self.mission3Complete = mission3Complete
        self.success = success
    }
}

struct ToDoView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @ObservedResults(MissionData.self)
    var userMissionList
    
    @State private var mission1 = ""
    @State private var mission2 = ""
    @State private var mission3 = ""
    
    @State private var weatherIcon: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        
        
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
                .offset(y: -40)
            }
            
            Spacer()
        }
        .onAppear {
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        }
    }
    
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
                
                VStack(alignment: .leading, spacing: 30) {
                    Text(time)
                        .font(.system(size: 24).bold())
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
                    AsyncImage(url: iconURL) { image in
                        image.resizable()
                            .frame(width: 70, height: 70)
                    } placeholder: {
                        ProgressView()
                    }
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
            //            print("2")
            return true
        } else if UserDefaultsManager.saying == "" {
            //            print("3")
            return true
        } else {
            //            print("4")
            return false
        }
    }
    func buttonView() -> some View {
        Button {
            let date = Date()
            
            let todayDate = Date.todayDate(from: date)
            let wakeuptime = Date.getWakeUpTime(from: date)
            
            let mission = MissionData(todayDate: todayDate, wakeUpTime: wakeuptime, mission1: mission1, mission2: mission2, mission3: mission3)
            
            $userMissionList.append(mission)
            
            print("usermissionlist = ", userMissionList)
        } label: {
            Image((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? "file" : "sad")
                .resizable()
                .frame(width: 40, height: 40)
            Text("저장")
                .font(.system(size: 24).bold())
                .foregroundStyle((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? .blue : .gray)
        }
        .disabled(!(!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty))
    }
}

struct ViewBackground: View {
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#469AF6"), Color(hex: "#F3D8A3")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    
}


struct FoldedCornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                          control: CGPoint(x: rect.midX, y: rect.midY))
        return path
    }
}
#Preview {
    TabBarView()
}

