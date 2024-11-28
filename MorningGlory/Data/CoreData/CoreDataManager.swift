//
//  CoreDataManager.swift
//  MorningGlory
//
//  Created by 최대성 on 11/27/24.
//

import CoreData

// 모든 핵심 데이터 관련 기능을 캡슐화할 관찰 가능한 클래스를 정의
final class CoreDataManager: ObservableObject {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MissionDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext { return self.persistentContainer.viewContext }
}

extension CoreDataManager {
    
    func fetchMissions() {
        let request: NSFetchRequest<Missions> = Missions.fetchRequest()
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            print("Fetched Missions: \(results)")
        } catch {
            print("Failed to fetch missions: \(error)")
        }
    }
    
    func addMission(todayDate: Date, startTime: Date, endTime: Date, mission: String, missionComplete: Bool) {
        let newMission = Missions(context: context)
        newMission.todayDate = todayDate
        newMission.startTime = startTime
        newMission.endTime = endTime
        newMission.mission = mission
        newMission.missionComplete = missionComplete
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
