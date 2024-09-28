//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//
import SwiftUI

struct ToDoView: View {
    @StateObject private var todoVM = ToDoVM()
    @StateObject private var calendarVM = CalendarVM()
    @State private var wakeUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                sayingView()
                    .frame(height: 180)
                
                wakeUpView()
                
                missionListView()
                Spacer()
            }
            .padding(.top)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { buttonView() }
            }
            .background(Color(hex: "#d7eff9"))
            .navigationTitle("Mission")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if let list = todoVM.output.filteredMissionList.first {
                    wakeUp = list.wakeUpTime != nil
                }
            }
        }
        .toastView(toast: $todoVM.output.toast)
    }
    
    // Wake Up View
    func wakeUpView() -> some View {
        HStack {
            Image(wakeUp ? "smilesmilesmile" : "sadsadsadsad")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.leading, 10)
            
            ZStack(alignment: .leading) {
                RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight, .topRight])
                    .fill(PostItColor.yellow.background)
                    .frame(width: wakeUp ? 120 : 160, height: 40)
                
                Button(action: {
                    let date = Date()
                    wakeUp.toggle()
                    todoVM.action(.wakeUpTime(date))
                }) {
                    HStack {
                        Image(systemName: wakeUp ? "checkmark.square.fill" : "checkmark.square")
                            .foregroundStyle(.black)
                        
                        Text(wakeUp ? "기상완료" : "기상하셨나요?")
                            .customFontBold(size: 17)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.leading, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
    
    // Mission List View
    func missionListView() -> some View {
        VStack(spacing: 10) {
            MissionCards(time: PostItColor.pink.time, mission: $todoVM.output.mission1, backgroundColor: .white)
            MissionCards(time: PostItColor.yellow.time, mission: $todoVM.output.mission2, backgroundColor: .white)
            MissionCards(time: PostItColor.green.time, mission: $todoVM.output.mission3, backgroundColor: .white)
        }
        .padding(.bottom, 10)
    }
    
    // Saying View
    func sayingView() -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(hex: "#B2D3E3"))
                .shadow(radius: 5)
                .padding()
            
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "fef0ea"))
                    .frame(width: 80, height: 30)
                    .overlay(Text("Today").customFontRegular(size: 20))
                
                weatherView()
                
                Text(UserDefaultsManager.saying)
                    .customFontRegular(size: 20)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                //                    .padding(.bottom, 40)
            }
        }
        .frame(minHeight: 180, maxHeight: .infinity)
        .task {
            todoVM.action(.weather)
        }
    }
    
    // Weather View
    func weatherView() -> some View {
        HStack {
            if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(todoVM.output.weatherIcon)@2x.png") {
                AsyncImage(url: iconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .frame(width: 70, height: 70)
                    case .failure :
                        ProgressView()
                    @unknown default:
                        ProgressView()
                    }
                }
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.leading, 35)
                .padding(.trailing, 10)
            }
            
            Text(todoVM.output.weatherText)
                .customFontBold(size: 20)
            
            Spacer()
            
            Text(String(format: "%.1f℃", todoVM.output.temperature))
                .customFontBold(size: 24)
                .foregroundColor(.black)
                .padding(.trailing, 35)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // Button View
    func buttonView() -> some View {
        Button {
            todoVM.action(.mission)
        } label: {
            HStack {
                Image(todoVM.areAllMissionsFilled ? "smilesmilesmile" : "")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text("저장")
                    .font(.system(size: 24).bold())
                    .foregroundStyle(todoVM.areAllMissionsFilled ? .blue : .gray)
            }
        }
        .disabled(!todoVM.areAllMissionsFilled)
    }
}

struct MissionCards: View {
    var time: String
    @Binding var mission: String
    var backgroundColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(backgroundColor)
            .frame(height: 80)
            .overlay(
                HStack {
                    Text(time)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 10)
                    
                    TextField("미션을 입력하세요", text: $mission)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                    .padding(.horizontal, 20)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
    }
}
