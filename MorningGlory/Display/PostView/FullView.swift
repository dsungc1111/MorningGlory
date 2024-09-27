//
//  FullView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/25/24.
//

import SwiftUI
import RealmSwift

struct FullView: View {
    
    @ObservedResults(PostData.self)
    var postList
    
    private let realmRepo = RealmRepository()
    
    var body: some View {
        userReviewView()
    }
    
    private func userReviewView() -> some View {
        
        VStack(alignment: .leading) {
            
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
                                .scaledToFill()
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(Date.messageTime(writeDate: list.uploadDate, currentDate: Date()))
                                    .customFontRegular(size: 14)
                                    .foregroundStyle(.gray)
                                
                                Spacer() // 텍스트와 메뉴 사이 간격 설정
                                
                                Menu(content: {
                                    Button(action: {
                                        realmRepo.removeImageFromDocument(filename: "\(list.id)")
                                        realmRepo.removePost(postData: list)
                                    }, label: {
                                        Text("삭제")
                                        Image(systemName: "trash")
                                    })
                                    .frame(width: 80)
                                }, label: {
                                    Image(systemName: "ellipsis.circle")
                                })
                                .foregroundStyle(.gray)
                                .padding(.top, 5) 
                            }
                        
                            
                            Text(list.feeling)
                                .customFontRegular(size: 18)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                        
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    
}

