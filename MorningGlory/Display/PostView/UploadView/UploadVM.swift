//
//  UploadVM.swift
//  MorningGlory
//
//  Created by 최대성 on 9/24/24.
//

import SwiftUI
import Combine

final class UploadVM: ViewModelType {
    
    struct Input {
        let savePost = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        
        var PHPickerOn = false
        var showCamera = false
        var text = ""
        
        var imageData: Data?
    }
    
    private var realmRepo = RealmRepository()
    
    enum Action {
        case savePost
    }
 
    var input = Input()
    
    @Published
    var output = Output()
    
    var cancellables = Set<AnyCancellable>()
    
    
    init() {
        transform()
    }
    
    func transform() {
        input.savePost
            .sink { [weak self] data in
                guard let self else { return }
                saveUserPost()
            }
            .store(in: &cancellables)
    }
    
    func action(_ action: Action) {
        
        switch action {
        case .savePost:
            input.savePost.send(())
        }
        
    }
    
    
    func saveUserPost() {
        let date = Date()
        let postData = PostData(uploadDate: date, feeling: output.text)
        
        realmRepo.savePost(postData)

        if let image = output.imageData {
            realmRepo.saveImageToDocument(image: image, filename: "\(postData.id)")
        }
    }
    
}