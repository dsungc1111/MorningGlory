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
                ViewBackground()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) { buttonView() }
                    }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        sayingView()
                        missionList()
                    }
                    .padding(.top)
                }
            }
//            .navigationTitle("임시제목")
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
            postItView(backGround: PostItColor.pink.background, fold: PostItColor.pink.foldColor, time: PostItColor.pink.time, textfield: $todoVM.output.mission1)
            
            postItView(backGround: PostItColor.yellow.background, fold: PostItColor.yellow.foldColor, time: PostItColor.yellow.time, textfield: $todoVM.output.mission2)
            
            postItView(backGround: PostItColor.orange.background, fold: PostItColor.orange.foldColor, time: PostItColor.orange.time, textfield: $todoVM.output.mission3)
            Spacer()
        }
    }
    
    func postItView(backGround: String, fold: String, time: String, textfield: Binding<String>) -> some View {
        
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
            FoldedCornerShape()
                .fill(Color(hex: fold))
                .frame(width: 50, height: 50)
                .padding(.trailing, 20)
        }
        
    }
    
    func sayingView() -> some View {
        HStack {
            VStack {
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
                    .frame(width: 70, height: 70)
                }
                Text( String(format: "%.1f", todoVM.output.temperature)  + "℃")
            }
            Text(UserDefaultsManager.saying)
                .foregroundColor(.black)
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .task {
            todoVM.action(.weather)
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


#Preview {
    TabBarView()
}

