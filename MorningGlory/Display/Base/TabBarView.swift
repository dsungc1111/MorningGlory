//
//  ContentView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

struct TabBarView: View {

    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color(hex: "#d7eff9"))

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance

            
            let tabbar = UITabBarAppearance()
            tabbar.backgroundColor = UIColor(Color(hex: "#d7eff9"))
            tabbar.stackedLayoutAppearance.selected.iconColor = .black
            tabbar.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]

            UITabBar.appearance().standardAppearance = tabbar
            UITabBar.appearance().scrollEdgeAppearance = tabbar
        }
    
    @State private var selectedTab: Int = 2
    
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
                               Text("Mission")
                           }
                           .tag(1)
                       CalendarView()
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
