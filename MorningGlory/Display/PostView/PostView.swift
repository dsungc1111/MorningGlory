
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
            VStack(alignment: .leading) {
                Text("\(postList.count)개의 글")
                    .customFontRegular(size: 20)
                    .padding()
                    .padding(.leading, 10)
                    .navigationTitle("인증샷")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showPageSheet = true
                            }, label: {
                                HStack {
                                    Text("글 추가")
                                        .customFontRegular(size: 16)
                                        .foregroundStyle(.black)
                                }
                            })
                            .sheet(isPresented: $showPageSheet) {
                                UploadView()
                            }
                        }
                        
                    }
                ForEach(postList.reversed()) { list in
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white).opacity(0.6)
                            .padding(.horizontal, 20)
                        VStack(alignment: .leading) {
                            
                            if let imageData = RealmRepository().loadImageToDocument(filename: "\(list.id)") {
                                Image(uiImage: imageData)
                                    .resizable()
                                    .frame(height: 250)
                                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                                    .padding(.horizontal, 20)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text(Date.messageTime(writeDate: list.uploadDate, currentDate: Date()))
                                    .customFontRegular(size: 14)
                                    .padding(.top, 5)
                                
                                
                                
                                Text(list.feeling)
                                    .customFontRegular(size: 18)
                            }
                            .padding(.horizontal, 40)
                            .padding(.bottom, 30)
                            
                        }
                    }
                }.padding(.bottom, 20)
            }
            
        }
        
    }
}
