//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

enum PostItColor {
    static let pink = PostItItem(background: "#FCC8C8", foldColor: "#FF8D8D", time: "05:30")
    static let yellow = PostItItem(background: "#F2F5D5", foldColor: "#FCEB00", time: "06:30")
    static let orange = PostItItem(background: "FFD9AA", foldColor: "FDBD70", time: "07:30")
}

struct PostItItem {
    let background: String
    let foldColor: String
    let time: String
}

struct ToDoView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var mission1 = ""
    @State private var mission2 = ""
    @State private var mission3 = ""
    
    @State private var weatherIcon: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        KeyBoardManager().frame(width: 0, height: 0)
        
        VStack {
            sayingView()
            missionList()
        }
    }
    
    func buttonView() -> some View {
        Button {
            print("저장저장!")
        } label: {
            Image((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? "file" : "sad")
                .resizable()
                .frame(width: 60, height: 60)
            Text("저장")
                .font(.system(size: 24).bold())
                .foregroundStyle((!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty) ? .blue : .gray)
        }
        .disabled(!(!mission1.isEmpty && !mission2.isEmpty && !mission3.isEmpty))
    }
    
    func missionList() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#C8CAFC"))
                    .padding(.horizontal, 20)
                    .frame(height: 60)
                    .shadow(radius: 5)
                    Text("5시 기상")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                        .offset(x: -120)
                    
                    buttonView()
            }
            
            postItView(backGround: PostItColor.pink.background, fold: PostItColor.pink.foldColor, time: PostItColor.pink.time, textfield: $mission1)
            
            
            postItView(backGround: PostItColor.yellow.background, fold: PostItColor.yellow.foldColor, time: PostItColor.yellow.time, textfield: $mission2)
            
            
            postItView(backGround: PostItColor.orange.background, fold: PostItColor.orange.foldColor, time: PostItColor.orange.time, textfield: $mission3)
            
            
        }
        
    }
    func postItView(backGround: String, fold: String, time: String, textfield: Binding<String>) -> some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(hex: backGround))
                .frame(height: 130)
                .overlay(
                    FoldedCornerShape()
                        .fill(Color(hex: fold))
                        .frame(width: 50, height: 50)
                        .offset(x: 170, y: 40)
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
            VStack(alignment: .leading, spacing: 30) {
                Text(time)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                TextField("미션을 입력하세요", text: textfield)
                    .font(.title2)
            }
            .padding(.leading, 10)
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
        
    }
 
    func saveInfo() {
        print("과연 여기가 실행이될까요?")
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
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text( String(format: "%.1f", temperature)  + "℃")
            }
               Text(UserDefaultsManager.saying)
                .foregroundColor(.black)
                   .font(.system(size: 20))
                   .multilineTextAlignment(.leading)
                   .frame(maxWidth: .infinity, alignment: .leading)
           }
           .padding()
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
 
