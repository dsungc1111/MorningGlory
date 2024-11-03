//
//  UserDefaults+.swift
//  MorningGlory
//
//  Created by 최대성 on 11/3/24.
//

import Foundation


extension UserDefaults {
    
    static var groupShared: UserDefaults {
        let appID = "group.com.morningGlory"
        return UserDefaults(suiteName: appID)!
    }
    
}
