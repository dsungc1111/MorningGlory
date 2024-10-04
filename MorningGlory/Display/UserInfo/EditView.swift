//
//  EditView.swift
//  MorningGlory
//
//  Created by 최대성 on 10/4/24.
//

import SwiftUI

struct EditView: View {
    
    @State private var text = ""
    
    @State private var removeNickname = ""
    @Environment(\.dismiss) private var dismiss
    @State private var showCamera = false
    @State private var imageData: Data?
    
    
    @Binding var usernickname: String
    
    private let realmRepo = RealmRepository()
    
    var body: some View {
      mainView()
    }
    
    func mainView() -> some View {
        
        VStack(alignment: .center) {
            Spacer()
            
            Button(action: {
                saveUserInfo()
                dismiss()
            }, label: {
                HStack {
                    Text("Save")
                        .customFontBold(size: 40)
                        .foregroundStyle(text.isEmpty ? .gray :.black)
                }
            })
            .padding(.bottom, 20)
            .onAppear() {
                removeNickname = UserDefaultsManager.nickname
                if imageData == nil {
                    if let realImage = UIImage(named: "smilesmilesmile"),
                       let imageData = realImage.pngData() {
                        self.imageData = imageData
                    }
                }
            }
            
         
            profileImageButton()
            textFieldView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       
    }
    
    func saveUserInfo() {
        UserDefaultsManager.nickname = text.isEmpty ? UserDefaultsManager.nickname : text
        usernickname = UserDefaultsManager.nickname
        if let image = imageData {
            realmRepo.removeImageFromDocument(filename: removeNickname)
            realmRepo.saveImageToDocument(image: image, filename: UserDefaultsManager.nickname)
        }
        
    }
    
    func profileImageButton() -> some View {
        Button {
            showCamera.toggle()
        } label: {
            
            if let imageData = imageData,
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 20)
            } else {
                Image("smilesmilesmile")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showCamera, content: {
            ImagePicker(selectedImage: Binding(get: {
                if let data = imageData {
                    return UIImage(data: data)
                }
                return nil
            }, set: { newImage in
                if let newImage = newImage {
                    if let data = newImage.pngData() {
                        imageData = data
                    }
                }
            })
            )
            
        })
    }
    
    func textFieldView() -> some View {
        HStack {
            TextField("닉네임을 입력하세요.", text: $text)
                .customFontRegular(size: 20)
                .frame(width: 160)
                .multilineTextAlignment(.leading)
        }
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
       
    }
}
