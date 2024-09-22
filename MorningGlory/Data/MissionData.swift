//
//  MissionData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/18/24.
//

import Foundation
import RealmSwift

struct MissionList {
    let mission1: String
    let mission2: String
    let mission3: String
}

final class MissionData: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todayDate: Date
    @Persisted var wakeUpTime: Date
    @Persisted var mission1: String
    @Persisted var mission2: String
    @Persisted var mission3: String
    @Persisted var mission1Complete: Bool
    @Persisted var mission2Complete: Bool
    @Persisted var mission3Complete: Bool
    @Persisted var success: Bool
    
    convenience init(todayDate: Date, wakeUpTime: Date, mission1: String, mission2: String, mission3: String, mission1Complete: Bool = false, mission2Complete: Bool = false, mission3Complete: Bool = false, success: Bool = false) {
        self.init()
        self.todayDate = todayDate
        self.mission1 = mission1
        self.mission2 = mission2
        self.mission3 = mission3
        self.wakeUpTime = wakeUpTime
        self.mission1Complete = mission1Complete
        self.mission2Complete = mission2Complete
        self.mission3Complete = mission3Complete
        self.success = success
    }
}
