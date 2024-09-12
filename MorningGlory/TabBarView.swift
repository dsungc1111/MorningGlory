//
//  ContentView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI


struct TabBarView: View {
    @State private var selectedTab: Int = 2
    
    @State private var date = Date()
    
    var body: some View {
        Spacer()
        tabbarView()
    }
    
    private func tabbarView() -> some View {
        VStack {
            VStack {
                switch selectedTab {
                case 1:
                    PostView()
                case 2:
                    CalendarView(currentDate: $date)
                case 3:
                    UserInfoView()
                case 4:
                    PostView()
                default:
                    CalendarView(currentDate: $date)
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
            .background(Color(UIColor.systemBackground).shadow(radius: 20))
            .clipShape(Capsule())
            .shadow(radius: 10)
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
