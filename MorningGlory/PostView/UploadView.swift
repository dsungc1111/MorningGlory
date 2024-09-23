//
//  UploadView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import SwiftUI
import RealmSwift
import Photos
import PhotosUI

struct UploadView: View {
    
    @Environment(\.dismiss) var dismiss
    
    private var realmRepo = RealmRepository()
    
    @ObservedResults(PostData.self)
    var postData
    
    @State private var PHPickerOn = false
    @State private var showCamera = false
    
    @State private var image: UIImage?
    @State private var text = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.circle")
                        Text("닉네임아스파라거스")
                            .font(.system(size: 15).bold())
                    }
                    .padding(.leading, 20)
                    
                    TextWritingView(text: $text)
                        .padding(.horizontal, 10)

                }
                HStack {
                    Spacer()
                    Button(action: {
                        PHPickerOn = true
                    }, label: {
                        Image(systemName: "photo.badge.plus")
                            .font(.headline)
                            .foregroundStyle(Color(uiColor: .lightGray))
                    })
                    .sheet(isPresented: $PHPickerOn, content: {
                        ImagePicker(selectedImage: $image)
                    })
                    .navigationTitle("New Post")
                    
                    Button(action: {
                        showCamera = true
                    }, label: {
                        Image(systemName: "camera")
                            .font(.headline)
                            .foregroundStyle(Color(uiColor: .lightGray))
                    })
                    .sheet(isPresented: $showCamera, content: {
                        CameraView(selectedImage: $image)
                    })
                }
                .padding(.horizontal, 20)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .frame(width: 200, height: 250)
                }
                

                Spacer()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 20)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(Color(hex: "#d7eff9"))
            .toolbar {
                Button {
                    if let image = image {
                        realmRepo.saveImageToDocument(image: image, filename: "\(image)")
                    }
                    let date = Date()
                    let postData = PostData(uploadDate: date, feeling: text)
                    $postData.append(postData)
                    dismiss()
                } label: {
                    Text("저장")
                }
            }
        }
    }
}

#Preview {
    UploadView()
}

struct TextWritingView: View {
    @State private var height: CGFloat = 30
    @Binding var text: String
 
    var body: some View {
        
        HStack(alignment: .bottom, spacing: 10) {
            
            CustomTextView(
                text: $text,
                height: $height,
                maxHeight: 220,
                textFont: .boldSystemFont(ofSize: 14),
                cornerRadius: 5,
                borderWidth: 1,
                borderColor: CGColor.init(red: 255, green: 255, blue: 255, alpha: 1),
                placeholder: "댓글을 입력해 주세요"
            )
            .frame(minHeight: height, maxHeight: .infinity)
         
        }
        .padding(.all, 10)
        .frame(height: 50)
        .frame(minHeight: height + 20)
        
        Text("\(text.count) / 300")
            .foregroundColor(Color(UIColor.lightGray))
            .padding(.leading, 15)
    }
}
