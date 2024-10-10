//
//  PostVM.swift
//  MorningGlory
//
//  Created by 최대성 on 10/8/24.
//

import SwiftUI
import Combine


final class PostVM: ViewModelType {
    
    enum Action {
        case pageSheet
    }
    
    struct Input {
        let isPageSheetOn = PassthroughSubject<Void, Never>()
    }
    struct Output {
        var selection = 0
        var showPageSheet = false
        var selectedPost: PostData = PostData(uploadDate: Date(), feeling: "")
        var isPresented: Bool = false
    }
    
    var input = Input()
    
    @Published
    var output = Output()
    
    var cancellables = Set<AnyCancellable>()
    
    private var postRepo: DatabaseRepository
    
    init(postRepo: DatabaseRepository) {
        self.postRepo = postRepo
        transform()
    }
    
    func transform() {
        input.isPageSheetOn
            .sink { [weak self] _ in
                guard let self else{ return }
                isPageSheetOn()
            }
            .store(in: &cancellables)
    }
    
}

extension PostVM {
    func action(_ action: Action) {
        
        switch action {
        case .pageSheet:
            input.isPageSheetOn.send(())
        }
        
    }
    
    
    
    func isPageSheetOn() {
        output.showPageSheet = true
    }
}
