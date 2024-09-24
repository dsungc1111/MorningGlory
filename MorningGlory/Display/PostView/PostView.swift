
import SwiftUI
import RealmSwift

struct PostView: View {
    
    @ObservedResults(PostData.self)
    var postList
    
    @State private var showPageSheet = false

    var body: some View {
        
        NavigationView {
            userReviewView()
                .background(Color(hex: "#d7eff9"))
        }
    }
    
    private func userReviewView() -> some View {
        ScrollView(.vertical) {
            ForEach(postList.reversed()) { list in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.brown)
                        .frame(height: 200)
                        .padding(.horizontal, 20)
                    HStack(alignment: .top) {

                        
                        if let imageData = RealmRepository().loadImageToDocument(filename: "\(list.id)") {
                            Image(uiImage: imageData)
                                .resizable()
                                .frame(width: 180, height: 200)
                                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
                                .padding(.leading, 20)
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text(Date.messageTime(writeDate: list.uploadDate, currentDate: Date()))
                                .customFontRegular(size: 14)
                                
                            
                            Text(list.feeling)
                                .customFontBold(size: 18)
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
                                .customFontBold(size: 16)
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
