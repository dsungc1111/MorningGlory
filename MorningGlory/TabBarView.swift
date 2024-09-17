//
//  ContentView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI


import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 2
    @State private var date = Date()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#469AF6"), Color(hex: "#F3D8A3")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            TabView(selection: $selectedTab) {
                
                ToDoView()
                    .tabItem {
                        Image(systemName: "checkmark.circle.fill")
                        Text("ToDo")
                    }
                    .tag(1)

                CalendarView(currentDate: $date)
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(2)

                UserInfoView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("User")
                    }
                    .tag(3)

                PostView()
                    .tabItem {
                        Image(systemName: "text.below.photo")
                        Text("Posts")
                    }
                    .tag(4)
            }
            .accentColor(Color(hex: "#57a3ff"))
        }
    }
}

#Preview {
    TabBarView()
}
