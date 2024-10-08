//
//  UserDefaultsManager.swift
//  MorningGlory
//
//  Created by 최대성 on 9/13/24.
//

import Foundation
import SwiftUI


@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.string(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    @UserDefault(key: "time", defaultValue: Date())
    static var dayDate
    
    @UserDefault(key: "saying", defaultValue: "")
    static var saying
    
    @UserDefault(key: "usernickname", defaultValue: "")
    static var nickname
    
  
}
