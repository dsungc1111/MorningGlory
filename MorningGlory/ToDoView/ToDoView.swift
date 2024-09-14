//
//  ToDoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

struct ToDoView: View {
    
    @State private var mission1 = ""
    @State private var mission2 = ""
    @State private var mission3 = ""
    
    
    var body: some View {
        KeyBoardManager().edgesIgnoringSafeArea(.all)
        VStack {
            sayingView()
                .offset(y: -20)
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
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                HStack {
                    Text("05:00")
                        .font(.system(size: 20).bold())
                    timeCircle(circle: Circle())
                    Text("기상")
                        .font(.system(size: 20).bold())
                    Spacer()
                    buttonView()
                        .padding(.trailing, 30)
                }
//                Rectangle()
//                    .frame(width: 1, height: 20, alignment: .leading)
//                    .background(.red)
//                    .padding(.leading, 73)
//                    .offset(y: -20)
            }

            VStack(alignment: .leading) {
                HStack {
                    Text("05:30")
                        .font(.system(size: 20).bold())
                    timeCircle(circle: Circle())
                }
                HStack {
                    timelineBar()
                        .padding(.leading, 64)
                    ZStack {
                        TextField("", text: $mission1)
                            .font(.system(size: 24))
                            .frame(width: 250, height: 80)
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 85, height: 28)
                            Text("Mission1")
                                .foregroundStyle(.blue)
                                .background(.white)
                        }
                        .offset(x: -75, y: -42)
                    }
                }
            }
            .offset(y: -10)
            VStack(alignment: .leading) {
                HStack {
                    Text("06:30")
                        .font(.system(size: 20).bold())
                    timeCircle(circle: Circle())
                }
                HStack {
                    timelineBar()
                        .padding(.leading, 64)
                    ZStack {
                        TextField("", text: $mission2)
                            .font(.system(size: 24))
                            .frame(width: 250, height: 80)
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 85, height: 28)
                            Text("Mission2")
                                .foregroundStyle(.blue)
                                .background(.white)
                        }
                        .offset(x: -75, y: -42)
                    }
                }
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("07:30")
                        .font(.system(size: 20).bold())
                    timeCircle(circle: Circle())
                }
                HStack {
                    timelineBar()
                        .padding(.leading, 64)
                    ZStack {
                        TextField("", text: $mission3)
                            .font(.system(size: 24))
                            .frame(width: 250, height: 80)
                            .padding(.leading, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: 85, height: 28)
                            Text("Mission3")
                                .foregroundStyle(.blue)
                                .background(.white)
                        }
                        .offset(x: -75, y: -42)
                    }
                }
            }
            
           
        }
        .padding(.leading)
    }
    
    func timelineBar() -> some View {
        Rectangle()
            .frame(width: 1, height: 100, alignment: .leading)
            .background(.red)
            .padding(.leading, 9)
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
               Image(systemName: "cloud.sun.fill")
                   .resizable()
                   .cornerRadius(25)
                   .frame(width: 50, height: 50)
                   .padding()
               
               Text(UserDefaultsManager.saying)
                   .foregroundColor(Color(hex: "#57a3ff"))
                   .font(.system(size: 20).bold())
                   .multilineTextAlignment(.leading)
                   .frame(maxWidth: .infinity, alignment: .leading)
           }
           .padding() // 내부 여백 추가
           .background(
               RoundedRectangle(cornerRadius: 25)
                   .fill(Color(.white))
                   .shadow(radius: 10)
           )
           .padding()
           .task {
//               UserDefaultsManager.saying = ""
               print("명언", UserDefaultsManager.saying)
               print("시간", UserDefaultsManager.dayDate)
               print("과연", shouldFetchNewSaying())
               if shouldFetchNewSaying() { saveInfo() }
           }
        
        
    }
    func shouldFetchNewSaying() -> Bool {
        let lastFetchDate = UserDefaultsManager.dayDate
        let calendar = Calendar.current
        if let daysBetween = calendar.dateComponents([.day], from: lastFetchDate, to: Date()).day, daysBetween >= 1 {
            print("2")
            return true
        } else if UserDefaultsManager.saying == "" {
            print("3")
            return true
        } else {
            print("4")
            return false
        }
    }
}

#Preview {
    TabBarView()
}
