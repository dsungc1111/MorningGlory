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
    private let realmRepo = RealmRepository()
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var isPresented = false // 팝업 상태를 제어하는 변수
    @State private var selectedPost: PostData? // 선택된 포스트 데이터를 저장하는 변수
    @State private var postList: [PostData] = [] // postList 데이터

    var body: some View {
        mainView()
            .onAppear {
                postList = realmRepo.getAllPostList()
            }
            .popup(isPresented: $isPresented) {
                
                if let post = selectedPost {
                    DetailPopUpView(post: post)
                }
            }
    }

    private func mainView() -> some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(postList.reversed(), id: \.id) { post in
                    Button {
                        selectedPost = post // 해당 버튼의 포스트 데이터를 저장
                        isPresented = true  // 팝업을 표시
                    } label: {
                        if let imageData = realmRepo.loadImageToDocument(filename: "\(post.id)") {
                            Image(uiImage: imageData)
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
}

struct DetailPopUpView: View {
    var post: PostData // 전달받은 PostData

    var body: some View {
        VStack {
            // 전달된 postData를 이용해 이미지 및 텍스트 표시
            if let imageData = RealmRepository().loadImageToDocument(filename: "\(post.id)") {
                Image(uiImage: imageData)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
            }

            Text(post.feeling)
                .font(.headline)
                .background(Color.green)
                .padding(.horizontal, 40)
                .lineLimit(nil) // 모든 텍스트 표시
                .multilineTextAlignment(.leading) // 텍스트 정렬
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)

            Button("닫기") {
                // 팝업을 닫기 위해 'isPresented'를 false로 설정
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
