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
        VStack {
            sayingView()
            .task {
                print("명언", UserDefaultsManager.saying)
                print("시간", UserDefaultsManager.dayDate)
                print("과연", shouldFetchNewSaying())
                if shouldFetchNewSaying() {
                    saveInfo()
                }
            }
            missionList()
        }
    }
    
    
    func missionList() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    timeCircle(circle: Circle())
                    Text("5시 기상")
                        .font(.system(size: 20).bold())
                    Spacer()
                }
                
                Rectangle()
                    .frame(width: 1, height: 50, alignment: .leading)
                    .background(.red)
                    .padding(.leading, 9)
            }
           
            VStack(alignment: .leading) {
                HStack {
                    timeCircle(circle: Circle())
                    Text("5시 30분")
                        .font(.system(size: 20).bold())
                }
                HStack {
                    Rectangle()
                        .frame(width: 1, height: 50, alignment: .leading)
                        .background(.red)
                        .padding(.leading, 9)
                        .padding(.trailing, 50)
                    TextField("미션 1", text: $mission1)
                        .font(.system(size: 24))
                        .frame(width: 260)
                        .padding(.leading, 20)
                        .border(.black)
                }
            }
//            .padding()
            VStack(alignment: .leading) {
                HStack {
                    timeCircle(circle: Circle())
                    Text("6시 30분")
                        .font(.system(size: 20).bold())
                }
                Rectangle()
                    .frame(width: 1, height: 50, alignment: .leading)
                    .background(.red)
                    .padding(.leading, 9)
            }
            
            
            VStack(alignment: .leading) {
                HStack {
                    timeCircle(circle: Circle())
                    Text("7시 30분")
                        .font(.system(size: 20).bold())
                }
                Rectangle()
                    .frame(width: 1, height: 50, alignment: .leading)
                    .background(.red)
                    .padding(.leading, 9)
            }
            
            

        }
        .padding(.leading)
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
               Image("파랑우주먼지")
                   .resizable()
                   .cornerRadius(25)
                   .frame(width: 50, height: 50)
                   .padding()
               
               Text(UserDefaultsManager.saying)
                   .foregroundColor(.white)
                   .font(.system(size: 20).bold())
                   .multilineTextAlignment(.leading)
                   .frame(maxWidth: .infinity, alignment: .leading)
           }
           .padding() // 내부 여백 추가
           .background(
               RoundedRectangle(cornerRadius: 25.0)
                   .fill(Color(hex: "7d86ff").opacity(0.5))
           )
           .padding()
        
        
    }
    func shouldFetchNewSaying() -> Bool {
        let lastFetchDate = UserDefaultsManager.dayDate
        let calendar = Calendar.current
        if let daysBetween = calendar.dateComponents([.day], from: lastFetchDate, to: Date()).day, daysBetween >= 1 {
            return true // 하루 이상이 지난 경우
        } else if UserDefaultsManager.saying == "" {
            return true
        } else {
            return false // 아직 하루가 지나지 않음
        }
    }
}

#Preview {
    ToDoView()
}
