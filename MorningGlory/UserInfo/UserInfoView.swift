//
//  UserInfoView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

struct UserInfoView: View {
    
    let totalDays = 30
    let completedDays = 14
    
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    
    let totalDuration: Double = 60
    
    var body: some View {
        VStack {
            progressView()
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .fill(.gray)
                .frame(height: 100)
                .padding(.horizontal, 20)
        }
    }
    
    func progressView() -> some View {
        VStack {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, 60)
//                .animation(.linear(duration: 2.0), value: progress)
            
            Text("\(Int(progress * 100))% 완료")
                .font(.headline)
                .padding()
            
            Button(action: startProgress) {
                Text("Start Progress")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func startProgress() {
        
        timer?.invalidate()
        progress = 0.0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if progress < 1.0 {
                progress += 1.0 / totalDuration
            } else {
                timer?.invalidate()
            }
        }
    }
    
    
}

#Preview {
    UserInfoView()
}
