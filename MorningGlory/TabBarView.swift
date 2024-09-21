//
//  ContentView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI


import SwiftUI

struct TabBarView: View {

    init() {
          let appearance = UINavigationBarAppearance()
          appearance.configureWithOpaqueBackground()
          appearance.backgroundColor = UIColor(Color(hex: "#d7eff9"))

          appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]


          let scrollEdgeAppearance = UINavigationBarAppearance()
          scrollEdgeAppearance.configureWithTransparentBackground()
          scrollEdgeAppearance.backgroundColor = UIColor.clear

          UINavigationBar.appearance().standardAppearance = appearance
          UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
          UINavigationBar.appearance().compactAppearance = scrollEdgeAppearance
        
        let tabbar = UITabBarAppearance()
        tabbar.backgroundColor = UIColor(Color(hex: "#d7eff9"))
//
        let scrollTabbar = UITabBarAppearance()
        scrollTabbar.backgroundColor = UIColor(Color(hex: "#d7eff9"))
//
        UITabBar.appearance().scrollEdgeAppearance = tabbar
//        UITabBar.appearance().standardAppearance = tabbar
        UITabBar.appearance().standardAppearance = tabbar
      }
    
    @State private var selectedTab: Int = 2
    
    var body: some View {
        
        ZStack {
            KeyBoardManager().frame(width: 0, height: 0)
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
