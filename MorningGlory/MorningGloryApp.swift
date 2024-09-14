//
//  MorningGloryApp.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import FirebaseCore
//import RealmSwift


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

//    init() {
//        setupRealm()
//    }
    
    var body: some Scene {
        WindowGroup {
            
            TabBarView()
            
        }
    }
}
//func setupRealm() {
//       let config = Realm.Configuration(
//           schemaVersion: 0, // 스키마 버전이 바뀌면 증가시킴
//           migrationBlock: { migration, oldSchemaVersion in
//               if oldSchemaVersion < 0 {
//                   // 필요하다면 마이그레이션 코드 작성
//               }
//           }
//       )
//       Realm.Configuration.defaultConfiguration = config
//   }

