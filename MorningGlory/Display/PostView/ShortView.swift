//
//  ShortView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/25/24.
//import SwiftUI

import SwiftUI
import PopupView
import RealmSwift

struct ShortView: View {
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @Binding var isPresented: Bool
    
    @Binding var selectedPost: PostData
    
    private let realmRepo = RealmRepository()
    

    @ObservedResults(PostData.self)
    var postList
    
    
    var body: some View {
        mainView()
            .onAppear() {
                print("다시 생서애서ㅐㅇ러ㅑㄴ렁내ㅓ랴ㅐㄴ러")
            }
    }
    
    private func mainView() -> some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(postList.reversed(), id: \.id) { post in
                    Button {
                        selectedPost = post
                        isPresented = true
                    } label: {
                        if let imageData = realmRepo.loadImageToDocument(filename: "\(post.id)") {
                            Image(uiImage: imageData)
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .contextMenu {
                                    Button(action: {
                                        realmRepo.removeImageFromDocument(filename: "\(post.id)")
                                        realmRepo.removeData(data: post)
                                    }) {
                                        Text("삭제")
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                }

            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
}
// cliped
struct DetailView: View {
    
    @Binding var postData: PostData
    
    private let realmRepo = RealmRepository()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text("\(Date.dateToString(from: postData.uploadDate)) 의 기록" )
                        .customFontBold(size: 14)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                }
                if let imageData = realmRepo.loadImageToDocument(filename: "\(postData.id)") {
                    Image(uiImage: imageData)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal, 5)
                }
                
                Text("\(postData.feeling)")
                    .customFontRegular(size: 20)
                    .padding(.top, 10)
            }
            .padding(.bottom, 20)
           
            Spacer()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 20)
    }
}
