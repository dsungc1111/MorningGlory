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
          appearance.backgroundColor = UIColor(Color(hex: "#70a9e9"))

          appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]


          let scrollEdgeAppearance = UINavigationBarAppearance()
          scrollEdgeAppearance.configureWithTransparentBackground()
          scrollEdgeAppearance.backgroundColor = UIColor.clear

          UINavigationBar.appearance().standardAppearance = appearance
          UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
          UINavigationBar.appearance().compactAppearance = scrollEdgeAppearance
        
        let tabbar = UITabBarAppearance()
        tabbar.backgroundColor = UIColor(Color(hex: "#dbd0b4"))
//
        let scrollTabbar = UITabBarAppearance()
        scrollTabbar.backgroundColor = UIColor.clear
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
      
      private func tabbarView() -> some View {
          VStack {
              VStack {
                  switch selectedTab {
                  case 1:
                      ToDoView()
                  case 2:
                      CalendarView()
                  case 3:
                      UserInfoView()
                  case 4:
                      PostView()
                  default:
                      CalendarView()
                  }
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              HStack {
                  Spacer()
                  configureTabbar(image: "calendar", tabIndex: 1)
                  Spacer()
                  configureTabbar(image: "house.fill", tabIndex: 2)
                  Spacer()
                  configureTabbar(image: "person.crop.circle.fill", tabIndex: 3)
                  Spacer()
                  configureTabbar(image: "text.below.photo", tabIndex: 4)
                  Spacer()
              }
              .frame(width: 280)
              .padding(.horizontal)
              .padding(.vertical, 10)
              .background(Color(hex: "#e3d4ae").shadow(radius: 20))
              .clipShape(Capsule())
              .shadow(radius: 5)
          }
      }
      
    private func configureTabbar(image: String, tabIndex: Int) -> some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            
            Image(systemName: image)
                .foregroundColor(selectedTab == tabIndex ? .white : .gray)
                .padding()
                .background(selectedTab == tabIndex ? Color(hex: "#57a3ff") : Color.clear)
                .clipShape(Circle())
        }
    }
}

#Preview {
    TabBarView()
}
