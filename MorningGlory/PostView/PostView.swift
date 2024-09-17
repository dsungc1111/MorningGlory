
import SwiftUI

struct PostView: View {
    
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#78ade5"))
        
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = UIColor.clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                viewBackground()
                userReviewView()
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
struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    TabBarView()
}
