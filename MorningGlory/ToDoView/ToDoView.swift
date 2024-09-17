//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

struct ToDoView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var mission1 = ""
    @State private var mission2 = ""
    @State private var mission3 = ""
    
    @State private var weatherIcon: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        
        
        NavigationView {
            KeyBoardManager().frame(width: 0, height: 0)
            ZStack {
                viewBackground()
                VStack {
                    sayingView()
                    missionList()
                }
            }
            Spacer()
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
                            .frame(width: 80, height: 80)
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
    
    func buttonView() -> some View {
        Button {
            print("저장저장!")
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
    private func viewBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#469AF6"), Color(hex: "#F3D8A3")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                buttonView()
            }
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

