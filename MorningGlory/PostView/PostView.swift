
import SwiftUI

struct PostView: View {
    
    
    @State private var showPageSheet = false

    
    
    var body: some View {
        
        NavigationView {
            userReviewView()
                .background(Color(hex: "#d7eff9"))
        }
        
    }
    
    
    private func userReviewView() -> some View {
        ScrollView(.vertical) {
            ForEach(0..<2) { _ in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.brown)
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                    HStack(alignment: .top) {
                        Rectangle()
                            .frame(width: 180, height: 200)
                            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
                            .padding(.leading, 20)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("2024-04-04")
                                .bold()
                            Text("오미완!")
                        }
                        .padding()
                        
                    }
                }
            }
            .navigationTitle("인증샷")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showPageSheet = true
                    }, label: {
                        HStack {
                            Text("글 추가")
                                .foregroundStyle(.black)
                        }
                    })
                    .sheet(isPresented: $showPageSheet) {
                        UploadView()
                    }
                }
                
            }
            
        }
        
    }
}



#Preview {
    PostView()
}


//                            Image("file")
//                                .resizable()
//                                .frame(width: 40, height: 40)
//                                .shadow(color: Color.orange, radius: 10, x: 0, y: 0)
