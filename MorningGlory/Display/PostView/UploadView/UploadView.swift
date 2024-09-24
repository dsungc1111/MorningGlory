//
//  UploadView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import SwiftUI
import Photos
import PhotosUI

struct UploadView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var uploadVM = UploadVM()
    
    
    var body: some View {
        
        NavigationView {
            mainView()
        }
    }
    
    private func mainView() -> some View {
        VStack {
            userView()
            buttonView()
            
            if let imageData = uploadVM.output.imageData,
               let image = UIImage(data: imageData) {
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
                uploadVM.action(.savePost)
                dismiss()
            } label: {
                Text("저장")
                    .customFontRegular(size: 16)
                    .foregroundStyle(.black)
                    
            }
        }
    }
    
    private func userView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle")
                Text("닉네임아스파라거스")
                    .customFontRegular(size: 20)
                
            }
            .padding(.leading, 20)
            
            TextWritingView(text: $uploadVM.output.text)
                .padding(.horizontal, 10)
        }
    }
    
    private func buttonView() -> some View {
        HStack {
            Spacer()
            // 갤러리
            Button(action: {
                uploadVM.output.PHPickerOn = true
            }, label: {
                Image(systemName: "photo.badge.plus")
                    .font(.headline)
                    .foregroundStyle(Color(uiColor: .lightGray))
            })
            .sheet(isPresented: $uploadVM.output.PHPickerOn, content: {
                ImagePicker(selectedImage: Binding(
                    get: {
                        if let data = uploadVM.output.imageData {
                            return UIImage(data: data)
                        }
                        return nil
                    },
                    set: { newImage in
                        if let newImage = newImage,
                           let data = newImage.pngData() {
                            uploadVM.output.imageData = data
                        }
                    })
                )
                .ignoresSafeArea(.all, edges: .bottom)
            })
            .navigationTitle("New Post")
            
            // 카메라
            Button(action: {
                uploadVM.output.showCamera = true
            }, label: {
                Image(systemName: "camera")
                    .font(.headline)
                    .foregroundStyle(Color(uiColor: .lightGray))
            })
            .sheet(isPresented: $uploadVM.output.showCamera, content: {
                CameraView(selectedImage: Binding(get: {
                    if let data = uploadVM.output.imageData {
                        return UIImage(data: data)
                    }
                    return nil
                }, set: { newImage in
                    if let newImage = newImage,
                       let data = newImage.pngData() {
                        uploadVM.output.imageData = data
                    }
                })
                )
                
            })
        }
        .padding(.horizontal, 20)
    }
}
