
import SwiftUI
import RealmSwift

struct PostView: View {
    
    @State private var selection = 0
    @State private var showPageSheet = false
    
    
    @ObservedResults(PostData.self)
    var postList
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                userView()
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                
                segementedControlView()
                
            }
            .background(Color(hex: "#d7eff9"))
        }
    }
    
    private func segementedControlView() -> some View {
        
        VStack {
            HStack {
                Text("\(postList.count)개의 글")
                    .customFontRegular(size: 20)
                    .padding(.leading, 25)
                Spacer()
                Picker(selection: $selection, label: Text("Picker")) {
                    Image(systemName: "squareshape").tag(0)
                    Image(systemName: "square.grid.3x3").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 80)
                .padding(.trailing, 20)
            }
            ScrollView(.vertical, showsIndicators: false) {
                if selection == 0 {
                    FullView()
                    
                } else {
                    ShortView()
                }
                
            }
        }
    }
    
    private func userView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.6))
                .padding(.horizontal, 25)
                .frame(height: 100)
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
            HStack {
                RoundedRectangle(cornerRadius: 35)
                    .frame(width: 70, height: 70)
                    .padding(.trailing, 20)
                Text("닉네임 Zone")
                    .customFontRegular(size: 24)
            }
            .padding(.leading, 50)
        }
    }
}
