//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import Toast
import RealmSwift


struct ToDoView: View {
    
    @StateObject private var todoVM = ToDoVM()
    
    @StateObject private var calendarVM = CalendarVM()
    
    @State private var wakeUp = false
    
    @ObservedResults(MissionData.self)
    var userMissionList
    
    var body: some View {
        mainView()
            .toastView(toast: $todoVM.output.toast)
    }
    
    
    func mainView() -> some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        sayingView()
                            .padding(.bottom, 10)
                        
                        HStack {
                            Image(wakeUp ? "file" : "sleep")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .padding(.leading, 10)
                            ZStack(alignment: .leading) {
                                RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight, .topRight])
                                    .fill( PostItColor.yellow.background)
                                    .frame(width: 150, height: 40)
                                Button(action: {
                                    if let mission = userMissionList.first {
                                        let date = Date()
                                        calendarVM.action(.saveWakeUptime((mission, date)))
                                    }
                                    wakeUp.toggle()
                                }, label: {
                                    Image(systemName: wakeUp ? "checkmark.square.fill" : "checkmark.square")
                                    Text(wakeUp ? "기상완료" : "기상하셨나요?")
                                        .foregroundStyle(.black)
                                })
                                .padding(.leading, 10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                        missionList()
                        
                    }
                    .padding(.top)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) { buttonView() }
                }
                .background(Color(hex: "#d7eff9"))
            }
            .navigationTitle("Mission")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            Spacer()
        }
    }
    
}

//MARK: - about View
extension ToDoView {
    
    func missionList() -> some View {
        VStack {
            
            MissionCards(time: PostItColor.pink.time, mission: $todoVM.output.mission1, backgroundColor: PostItColor.pink.background)
                .padding(.bottom, 10)
            MissionCards(time: PostItColor.yellow.time, mission: $todoVM.output.mission2, backgroundColor: PostItColor.yellow.background)
                .padding(.bottom, 10)
            MissionCards(time: PostItColor.green.time, mission: $todoVM.output.mission3, backgroundColor: PostItColor.green.background)
                .padding(.bottom, 10)
            Spacer()
        }
    }
    
    func postItView(backGround: String, time: String, textfield: Binding<String>) -> some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: backGround))
                    .frame(height: 130)
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
        }
        
    }
    
    func sayingView() -> some View {
        
        ZStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(hex: "#B2D3E3"))
                    .shadow(radius: 5)
                    
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "fef0ea"))
                            .frame(width: 80, height: 30)
                        Text("Today")
                            .bold()
                    }
                    .padding(.vertical, 10)

                    HStack {
                        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(todoVM.output.weatherIcon)@2x.png") {
                            AsyncImage(url: iconURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image.resizable()
                                        .frame(width: 70, height: 70)
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    ProgressView()
                                }
                            }
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                            .padding(.leading, 35)
                        }
                        Text(todoVM.output.weatherText)
                            .bold()
                        
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text( String(format: "%.1f", todoVM.output.temperature)  + "℃")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 35)
                    }
                    .padding(.bottom, 15)
                    
                    Text(UserDefaultsManager.saying)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                }
            }
            .padding()
            .task {
                todoVM.action(.weather)
            }
        }
    }
    func buttonView() -> some View {
        Button {
            todoVM.action(.mission)
        } label: {
            Image(todoVM.areAllMissionsFilled ? "file" : "")
                .resizable()
                .frame(width: 40, height: 40)
            Text("저장")
                .font(.system(size: 24).bold())
                .foregroundStyle(todoVM.areAllMissionsFilled ? .blue : .gray)
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
            .frame(height: 100)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .overlay(
                HStack {
                    Text(time)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 15)

                    TextField("미션을 입력하세요", text: $mission)
                        .font(.title)
                        .foregroundColor(.black)
                }
                    .padding(.horizontal, 40)
            )
    }
}


#Preview {
    TabBarView()
}

