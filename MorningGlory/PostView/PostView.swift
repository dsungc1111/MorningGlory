
import SwiftUI


struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 말풍선 본체 (Rounded Rectangle)
        path.addRoundedRect(in: CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 0.8), cornerSize: CGSize(width: 20, height: 20))

        // 말풍선 꼬리
        path.move(to: CGPoint(x: rect.width * 0.2, y: rect.height * 0.8))
        path.addLine(to: CGPoint(x: rect.width * 0.3, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width * 0.4, y: rect.height * 0.8))
        path.closeSubpath()

        return path
    }
}

struct PostView: View {
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                setNavigation()
                userReviewView()
                SpeechBubble()
            }
        }
    }
    
    
    
    
    private func setNavigation() -> some View {
        ViewBackground()
            .navigationTitle("인증샷")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("츄가버튼l")
                    }, label: {
                        HStack {
                            Image("file")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.orange, radius: 10, x: 0, y: 0)
                            Text("글 추가")
                                .foregroundStyle(.black)
                        }
                    })
                }
            }
    }
    
    private func viewBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "#469AF6"), Color(hex: "#F3D8A3")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
        
    }
    
    
    private func userReviewView() -> some View {
        ScrollView(.vertical) {
            ForEach(0..<2) { _ in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.brown)
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                    
                    
                    HStack {
                        Rectangle()
                            .frame(width: 180, height: 200)
                            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
                            .offset(x: -32)
                        VStack(alignment: .leading, spacing: 20) {
                            Text("2024-04-04")
                                .bold()
                            Text("오미완!")
                        }
                        .offset(x: -30, y: -60)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
    }
    
}




#Preview {
    ContentView()
}


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // 상단 날씨 및 텍스트 영역
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                    .frame(height: 300)
                    .shadow(radius: 5)
                VStack {
                    HStack {
                        Image(systemName: "sun.max.fill") // 원하는 아이콘으로 대체
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                            .padding(.leading, 35)

                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("20.3°C")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            Text("흐림")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 35)
                    }
                    

                    Text("회의적인 세상이 지독한 의심으로 자신을 공격해도 언제나 자신을 믿어야 한다. 전 인류에 맞서 자신의 유일한 사도가 되어야 한다.")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                }
            }
            .padding()

            // 미션 카드들
            VStack(spacing: 15) {
                MissionCard(time: "05:30", mission: "미션을 입력하세요", backgroundColor: Color.pink.opacity(0.2))
                MissionCard(time: "06:30", mission: "미션을 입력하세요", backgroundColor: Color.yellow.opacity(0.2))
                MissionCard(time: "07:30", mission: "미션을 입력하세요", backgroundColor: Color.orange.opacity(0.2))
            }
            .padding(.horizontal)

            Spacer()

            // 하단 탭바
            HStack {
                TabBarItem(imageName: "checkmark.circle.fill", title: "ToDo", isSelected: true)
                TabBarItem(imageName: "calendar", title: "Calendar", isSelected: false)
                TabBarItem(imageName: "person.fill", title: "User", isSelected: false)
                TabBarItem(imageName: "photo.on.rectangle", title: "Posts", isSelected: false)
            }
            .frame(height: 70)
            .background(Color.white.shadow(radius: 5))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}

// 미션 카드 컴포넌트
struct MissionCard: View {
    var time: String
    var mission: String
    var backgroundColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(backgroundColor)
            .frame(height: 80)
            .overlay(
                HStack {
                    Text(time)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading, 20)

                    Spacer()

                    Text(mission)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                }
            )
    }
}

// 탭바 아이템 컴포넌트
struct TabBarItem: View {
    var imageName: String
    var title: String
    var isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? Color.blue : Color.gray)

            Text(title)
                .font(.footnote)
                .foregroundColor(isSelected ? Color.blue : Color.gray)
        }
        .padding(.top, 10)
    }
}

