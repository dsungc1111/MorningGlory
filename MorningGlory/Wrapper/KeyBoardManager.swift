//
//  KeyBoardManager.swift
//  MorningGlory
//
//  Created by 최대성 on 9/14/24.
//

import UIKit
import SwiftUI
import IQKeyboardManagerSwift

struct KeyBoardManager: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        return viewController
    }
    
    
}
