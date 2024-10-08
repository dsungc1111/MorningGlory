
import SwiftUI
import RealmSwift
import PopupView

struct PostView: View {
    
    @StateObject private var postVM = PostVM(postRepo: RealmRepository())
    
    @ObservedResults(PostData.self)
    var postList
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        NavigationView {
            segementedControlView()
                .navigationTitle("Post")
                .navigationBarTitleDisplayMode(.inline)
                .padding(.top, 20)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            postVM.action(.pageSheet)
                        }, label: {
                            HStack {
                                Text("글 추가")
                                    .customFontRegular(size: 16)
                                    .foregroundStyle(.black)
                            }
                        })
                        .sheet(isPresented: $postVM.output.showPageSheet) {
                            UploadView()
                        }
                    }
                }
                .popup(isPresented: $postVM.output.isPresented) {
                    DetailView(postData: $postVM.output.selectedPost)
                        .padding(.top, 200)
            } customize: {
                $0
                    .type(.toast)
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
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
                Picker(selection: $postVM.output.selection, label: Text("Picker")) {
                    Image(systemName: "squareshape").tag(0)
                    Image(systemName: "square.grid.3x3").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 80)
                .padding(.trailing, 20)
            }
            ScrollView(.vertical, showsIndicators: false) {
                if postVM.output.selection == 0 {
                    FullView()
                    
                } else {
                    ShortView(isPresented: $postVM.output.isPresented, selectedPost: $postVM.output.selectedPost)
                }
                
            }
        }
    }
    
}
