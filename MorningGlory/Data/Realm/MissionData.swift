//
//  MissionData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/18/24.
//

import Foundation
import RealmSwift

final class DateList: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var mission: List<MissionData>
    
    convenience init(mission: List<MissionData>) {
        self.init()
        self.mission = mission
    }
}


final class MissionData: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todayDate: Date
    @Persisted var wakeUpTime: Date?
    @Persisted var mission: String
    @Persisted var missionComplete: Bool
    
    @Persisted(originProperty: "mission") var main: LinkingObjects<DateList>
    
    convenience init(todayDate: Date, wakeUpTime: Date, mission: String, missionComplete: Bool, success: Bool = false) {
        self.init()
        self.todayDate = todayDate
        self.mission = mission
        self.missionComplete = missionComplete
        self.wakeUpTime = wakeUpTime
    }
}
