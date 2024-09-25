//
//  RealmRepository.swift
//  MorningGlory
//
//  Created by 최대성 on 9/23/24.
//

import SwiftUI
import RealmSwift


struct RealmRepository {
    
    private let realm = try! Realm()
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
        
        let objects = realm.objects(MissionData.self)
        
        return Array(objects)
    }
    
    func getAllPostList() -> [PostData] {
        let objects = realm.objects(PostData.self)
        
        return Array(objects)
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

