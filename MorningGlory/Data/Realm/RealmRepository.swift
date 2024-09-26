//
//  RealmRepository.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import SwiftUI
import RealmSwift


struct RealmRepository {
    
    private let calendar = Calendar.current
    
    @ObservedResults(MissionData.self)
    var missiondata
    
    @ObservedResults(PostData.self)
    var postdata
    
    func fetchURL() {
        print("urlurlrulrurlulrur",Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func savePost(_ postData: PostData) {
        
        $postdata.append(postData)
        
    }
    
    func saveMission(_ missionData: MissionData) {
        
        $missiondata.append(missionData)
        
    }
    
    func isMissionComplete(index: Int) -> Bool {
        
        
        switch index {
        case 1:
            missiondata[index].mission1Complete.toggle()
        case 2:
            missiondata[index].mission2Complete.toggle()
        case 3:
            missiondata[index].mission3Complete.toggle()
        default:
            break
        }
        if missiondata[index].mission1Complete && missiondata[index].mission2Complete && missiondata[index].mission3Complete {
            missiondata[index].success = true
        } else {
            missiondata[index].success = false
        }
        
        return missiondata[index].success
    }
    
    
    func getFetchedMissionList(todayDate: Date) -> [MissionData] {
        
        let startOfDay = calendar.startOfDay(for: todayDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let objects = missiondata.filter("todayDate >= %@ AND todayDate < %@", startOfDay, endOfDay)
        
        return Array(objects)
    }
    
    func getAllMissionList() -> [MissionData] {
        
        
        return Array(missiondata)
    }
    
    func getAllPostList() -> [PostData] {
        
        
        return Array(postdata)
    }
    
    
    func countSuccess() -> Int {
        
        
        var count = 0
        
        for item in missiondata {
            
            if item.success {
                count += 1
            }
            
        }
        return count
    }
    
    
    func countFail() -> Int {
        
        let date = Date()
        
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        
        guard let oldestDate = missiondata.sorted(byKeyPath: "todayDate", ascending: true).first?.todayDate else {
            return 0
        }
        print("👉👉👉👉👉startOfDay👈👈👈👈👈👈", startOfDay)
        print("👉👉👉👉👉endOfDay👈👈👈👈👈👈", endOfDay)
        print("👉👉👉👉👉저장된 가장 오래된 날짜👈👈👈👈👈👈", oldestDate)
        
        
        let objects = missiondata.filter("todayDate < %@", endOfDay)
        
        
        
        let recordedDates = Set(objects.map { calendar.startOfDay(for: $0.todayDate) })
        
        var count = 0
        
        var currentDate = calendar.startOfDay(for: oldestDate)
        
        
        while currentDate < startOfDay {
            print("🔫🔫🔫🔫🔫currentDate🔫🔫🔫🔫🔫", currentDate)
            if !recordedDates.contains(currentDate) {
                count += 1
            } else {
                if let mission = objects.first(where: { calendar.isDate($0.todayDate, inSameDayAs: currentDate) }) {
                    if mission.success == false {
                        count += 1
                    }
                }
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return count
    }
    
    
    func removePost(postData: PostData) {
        $postdata.remove(postData)
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

