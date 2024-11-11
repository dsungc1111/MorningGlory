//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//
import SwiftUI

struct ToDoView: View {
    
    @StateObject private var todoVM = ToDoVM(missionRepo: RealmRepository())

    @State private var wakeUp = false
    @State private var isAddMissionViewPageSheet = false
    
    @Environment(\.colorScheme) var scheme

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    sayingView()
                    checkWakeUpView()
                    missionListView()
                    Spacer()
                }
                .padding(.top)
                .navigationTitle("Mission").customFontBold(size: 16)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    if let list = todoVM.output.filteredMissionList.first {
                        wakeUp = list.wakeUpTime != nil
                        print("⭐️⭐️⭐️⭐️일어났니? >>>>>>> ", wakeUp)
                    }
                }
            }
            .background(Color(hex: "#d7eff9"))
        }
        .toastView(toast: $todoVM.output.toast)
    }
    
    // Wake Up + Mission add View
    func checkWakeUpView() -> some View {
            HStack {
                Button(action: {
                    let date = Date()
                    wakeUp.toggle()
                    todoVM.action(.wakeUpTime(date))
                }) {
                    HStack {
                        Image(systemName: wakeUp ? "checkmark.square.fill" : "checkmark.square")
                        Text(wakeUp ? "기상완료" : "기상하셨나요?").customFontBold(size: 17)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isAddMissionViewPageSheet.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("미션 추가").customFontBold(size: 17)
                    }
                })
                .sheet(isPresented: $isAddMissionViewPageSheet) {
                    
                    AddMissionView()
                        .presentationDetents([.fraction(0.5)])
                        .presentationDragIndicator(.visible)
                }
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 25)
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
                    .overlay(Text("Today").customFontRegular(size: 20)).foregroundStyle(.black)
                
                weatherView()
                
                Text(UserDefaultsManager.saying)
                    .customFontRegular(size: 20)
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
            }
            
        }
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
                .customFontBold(size: 20).foregroundStyle(.black)
            
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
                    .customFontRegular(size: 16)
                    .foregroundStyle(todoVM.areAllMissionsFilled ? .blue : .gray)
            }
        }
        .disabled(!todoVM.areAllMissionsFilled)
    }
}
