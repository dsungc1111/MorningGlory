//
//  ViewModelType.swift
//  MorningGlory
//
//  Created by 최대성 on 9/20/24.
//

import Foundation
import Combine

protocol ViewModelType: AnyObject, ObservableObject {
    
    
    associatedtype Action
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get set }
    
    var input: Input { get set }
    var output: Output { get set }
    
   
    func transform()
}
