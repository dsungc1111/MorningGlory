//
//  ShortView.swift
//  MorningGlory
//
//  Created by 최대성 on 9/25/24.
//

import SwiftUI
import RealmSwift

struct ShortView: View {
    
    private let realmRepo = RealmRepository()
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @ObservedResults(PostData.self)
    var postList
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(postList.reversed()) { list in
                    
                    if let imageData = RealmRepository().loadImageToDocument(filename: "\(list.id)") {
                        Image(uiImage: imageData)
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
