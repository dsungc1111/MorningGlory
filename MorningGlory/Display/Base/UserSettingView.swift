//
//  UserSettingView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/27/24.
//

import SwiftUI
import Photos
import PhotosUI

struct UserSettingView: View {
    
    @State private var usernickname = ""
    
    @State private var isNextPage = false
    @State private var showCamera = false
    @State private var imageData: Data?
    
    private let realmRepo = RealmRepository()
    
    var body: some View {
        NavigationView {
            mainView()
        }
    }
    
    func mainView() -> some View {
        
        VStack(alignment: .center) {
            Spacer()
            Button(action: {
                saveUserInfo()
                isNextPage.toggle()
            }, label: {
                HStack {
                    Text("Let's Go >")
                        .customFontBold(size: 40)
                        .foregroundStyle(usernickname.isEmpty ? .gray :.black)
                }
            })
            .padding(.bottom, 20)
            profileImageButton()
            textFieldView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func saveUserInfo() {
        UserDefaultsManager.nickname = usernickname
        if let image = imageData {
            realmRepo.saveImageToDocument(image: image, filename: UserDefaultsManager.nickname)
        }
        
    }
    
    func profileImageButton() -> some View {
        Button {
            showCamera.toggle()
            print("클릭")
        } label: {
            
            if let imageData = imageData,
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 100))
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 20)
            } else {
                
                Image("file")
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
            TextField("닉네임을 입력하세요.", text: $usernickname)
                .customFontRegular(size: 20)
                .frame(width: 160)
                .multilineTextAlignment(.leading)
        }
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
       
    }
    
    
}

#Preview {
    UserSettingView()
}
