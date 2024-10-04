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
    @StateObject private var uploadVM = UploadVM(postRepo: RealmRepository())
    
    private let realmRepo = RealmRepository()
    
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
                    .frame(height: 250)
                    .padding(.horizontal, 20)
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
                    .foregroundStyle(uploadVM.output.text.isEmpty ? .gray : .black)
                    
            }
            .disabled(uploadVM.output.text.isEmpty) 
        }
    }
    
    private func userView() -> some View {
        VStack(alignment: .leading) {
            HStack {
                if let imageData = realmRepo.loadImageToDocument(filename: UserDefaultsManager.nickname) {
                    Image(uiImage: imageData)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                        .scaledToFill()
                      
                }
                Text(UserDefaultsManager.nickname)
                    .customFontRegular(size: 16)
                
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
                Image(systemName: "photo")
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
                        if let newImage = newImage {
                            
                            let deviceWidth = UIScreen.main.bounds.width - 40
                            let targetHeight: CGFloat = 250
                            
                            
                            if newImage.size.height > targetHeight {
                                if let resizedImage = newImage.resize(toWidth: deviceWidth, toHeight: targetHeight),
                                   let data = resizedImage.pngData() {
                                    print("리사이즈 성공")
                                    uploadVM.output.imageData = data
                                }
                            } else if let resizedImage = newImage.resize(toWidth: deviceWidth, toHeight: newImage.size.height),
                                      let data = resizedImage.pngData() {
                                uploadVM.output.imageData = data
                            }
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
                    if let newImage = newImage {
                        if let data = newImage.pngData() {
                            uploadVM.output.imageData = data
                            
                        }
                    }
                })
                )
                
            })
        }
        .padding(.horizontal, 20)
    }
}
