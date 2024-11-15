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
    @Persisted var today: Date
    
    convenience init(mission: List<MissionData>, today: Date) {
        self.init()
        self.mission = mission
        self.today = today
    }
}


final class MissionData: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var todayDate: Date
    @Persisted var wakeUpTime: Date?
    @Persisted var startTime: Date
    @Persisted var endTiem: Date
    @Persisted var mission: String
    @Persisted var missionComplete: Bool
    
    @Persisted(originProperty: "mission") var main: LinkingObjects<DateList>
    
    convenience init(todayDate: Date, wakeUpTime: Date, mission: String, missionComplete: Bool, startTime: Date, endTime: Date) {
        self.init()
        self.todayDate = todayDate
        self.mission = mission
        self.missionComplete = missionComplete
        self.wakeUpTime = wakeUpTime
        self.startTime = startTime
        self.endTiem = endTime
    }
}
