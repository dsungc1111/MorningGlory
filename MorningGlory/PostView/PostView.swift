//
//  PostView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI

// 날씨 정보 뷰 분리
struct WeatherView: View {
    var temperature: String
    var weatherIcon: String

    var body: some View {
        VStack {
            Image(systemName: weatherIcon) // 날씨 아이콘
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            Text("\(temperature)°C") // 온도 표시
                .font(.title)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

// 명언 뷰 분리
struct QuoteView: View {
    var quote: String

    var body: some View {
        Text(quote)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .padding()
    }
}
struct PostView: View {
    var body: some View {
          HStack {
              WeatherView(temperature: "22", weatherIcon: "cloud.sun.fill") // 왼쪽에 날씨 정보
              QuoteView(quote: "실수하며 보낸 인생은\n아무것도 하지 않은 인생보다\n더 유용하다.") // 오른쪽에 명언
          }
          .background(
              RoundedRectangle(cornerRadius: 25)
                  .fill(Color(.systemGray6))
                  .shadow(radius: 10)
          )
          .padding()
      }
}


#Preview {
    PostView()
}
