//
//  ToastComponents.swift
//  MorningGlory
//
//  Created by 최대성 on 9/19/24.
//

import SwiftUI


//MARK: - Toast case - <수정, 저장> + 배경색, 아이콘
enum ToastCase {
    case edit
    case success
}

extension ToastCase {
    
    var themeColor: Color {
        
        switch self {
        case .edit:
            return .green
        case .success:
            return .blue
        }
    }
    
    var iconString: String {
        switch self {
        case .edit:
            return "pencil.and.outline"
        case .success:
            return "checkmark.seal.fill"
        }
        
    }
    
}

//MARK: - 토스트 메시지 구성요소
struct Toast: Equatable {
    var type: ToastCase
    var title: String
    var message: String
    var duration: Double = 3
}

//MARK: - 토스트 뷰
struct ToastView: View {
    var type: ToastCase
    var title: String
    var message: String
    var cancelTapped: (() -> Void)
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: type.iconString)
                    .foregroundColor(type.themeColor)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                
                Button {
                    cancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}
