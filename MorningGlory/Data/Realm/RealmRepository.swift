//
//  RealmRepository.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import SwiftUI
import RealmSwift


protocol DatabaseRepository {
    
    func getFetchedMissionList(todayDate: Date) -> [MissionData]
    func missionComplete(missionData: MissionData, index: Int)
    
    func fetchData<T: Object>(of type: T.Type) -> [T]
    func removeData<T: Object>(data: T)
    func saveData<T: Object>(data: T)
    
    func saveImageToDocument(image: Data, filename: String)
    func loadImageToDocument(filename: String) -> UIImage?
    func removeImageFromDocument(filename: String)
    func saveOrUpdateMission(todayDate: Date, missionData: MissionData)
    
    var successCount: Int { get }
    var failCount: Int { get }
    func fetchDateList(for date: Date) -> DateList?
    func save(_ dateList: DateList)
}


final class RealmRepository: DatabaseRepository {
    
    
    private let calendar = Calendar.current
    
    private var missiondata: Results<MissionData> {
        
        let realm = try! Realm()
        return realm.objects(MissionData.self)
    }
    
    private var postdata: Results<PostData> {
        let realm = try! Realm()
        return realm.objects(PostData.self)
    }
    
    
    func fetchData<T: Object>(of type: T.Type) -> [T] {
        do {
            let realm = try Realm()
            return Array( realm.objects(T.self))
        } catch {
            print("에러: \(error)")
            return []
        }
    }
    
    func removeData<T: Object>(data: T) {
        
        do {
            
            guard let realm = data.realm else { return }
            
            let thawedRealm = realm.isFrozen ? realm.thaw() : realm
            
            let thawedData = data.isFrozen ? data.thaw() : data
            
            guard let validData = thawedData else { return }
            
            try thawedRealm.write {
                print("삭제할 데이터: \(validData)")
                thawedRealm.delete(validData)
            }
            
        } catch {
            print("데이터 삭제 에러: \(error)")
        }
    }
    
    
    func saveData<T: Object>(data: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("데이터 저장 에러: \(error)")
        }
    }
    
    func saveOrUpdateMission(todayDate: Date, missionData: MissionData) {
        
        //        if let existingMission = missiondata.filter("todayDate == %@", todayDate).first {
        //
        //            if let editMission = existingMission.thaw() {
        //                try? editMission.realm?.write {
        //
        //                }
        //                print("🔫🔫🔫🔫데이터 수정 완료: ", editMission)
        //            }
        //        } else {
        
        
        
        
        
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(missionData)
            }
            print("🔫🔫🔫🔫새 데이터 추가 완료: ", missionData)
        } catch {
            print("데이터 저장 에러: \(error)")
        }
        //        }
    }
    
    var successCount: Int {
        missiondata.filter("missionComplete == true").count
    }
    
    
    var failCount: Int {
        
        let date = Date()
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let oldestDate = missiondata.sorted(byKeyPath: "todayDate", ascending: true).first?.todayDate ?? startOfDay
        let objects = missiondata.filter("todayDate < %@", endOfDay)
        
        let recordedDates = Set( objects.map { [weak self] object in
            self?.calendar.startOfDay(for: object.todayDate)
        })
        var count = 0
        var currentDate = calendar.startOfDay(for: oldestDate)
        
        while currentDate < startOfDay {
            if !recordedDates.contains(currentDate) {
                count += 1
            } else {
                if let mission = objects.first(where: { calendar.isDate($0.todayDate, inSameDayAs: currentDate) }) {
                    //                    if mission.success == false {
                    //                        count += 1
                    //                    }
                }
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return count
    }
    
    func missionComplete(missionData: MissionData, index: Int)  {
        
        if let mission = missionData.thaw() {
            try? mission.realm?.write {
                switch index {
                case 1:
                    mission.missionComplete.toggle()
                case 2:
                    mission.missionComplete.toggle()
                case 3:
                    mission.missionComplete.toggle()
                default:
                    break
                }
                
                
            }
        }
        
        //        return missiondata[index].success
    }
    
    func getFetchedMissionList(todayDate: Date) -> [MissionData] {
        let startOfDay = calendar.startOfDay(for: todayDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let objects = missiondata.filter("todayDate >= %@ AND todayDate < %@", startOfDay, endOfDay)
        return Array(objects)
    }
    func fetchDateList(for date: Date) -> DateList? {
        let realm = try! Realm()
        return realm.objects(DateList.self).filter("today == %@", date).first
    }
    
    func save(_ dateList: DateList) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(dateList)
        }
    }
    
}


//MARK: About Image
extension RealmRepository {
    
    func saveImageToDocument(image: Data, filename: String) {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        guard let newimage = UIImage(data: image) else { return }
        guard let data = newimage.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("file remove error", error)
            }
        } else {
            print("file no exist")
        }
    }
}

