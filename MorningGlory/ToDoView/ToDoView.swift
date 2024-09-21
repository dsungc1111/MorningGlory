//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import Toast


struct ToDoView: View {
    
    @StateObject private var todoVM = ToDoVM()
    
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
                        
                        missionList()
                        
                    }
                    .padding(.top)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) { buttonView() }
                }
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
            MissionCards(time: PostItColor.yellow.time, mission: $todoVM.output.mission2, backgroundColor: PostItColor.yellow.background)
            MissionCards(time: PostItColor.orange.time, mission: $todoVM.output.mission3, backgroundColor: PostItColor.orange.background)
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
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                    .frame(height: 200)
                    .shadow(radius: 5)
                VStack {
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
                                    Image(systemName: "sun.max.circle")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                @unknown default:
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                }
                            }
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                            .padding(.leading, 35)
                        }
                        
                        
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text( String(format: "%.1f", todoVM.output.temperature)  + "℃")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .padding(.trailing, 35)
                    }
                    
                    
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

                    Spacer()

                    TextField("미션을 입력하세요", text: $mission)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                    .padding(.horizontal, 40)
            )
    }
}


#Preview {
    TabBarView()
}

