//
//  MorningGloryApp.swift
//  MorningGlory
//
//  Created by 최대성 on 9/12/24.
//

import SwiftUI
import FirebaseCore
import RealmSwift


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupRealm()
        return true
    }
}


@main
struct YourApp: SwiftUI.App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                if UserDefaultsManager.nickname == "" {
                    UserSettingView()
                } else {
                    TabBarView()
                }
                KeyBoardManager().frame(width: 0, height: 0)
            }
        }
    }
}
func setupRealm() {
    let config = Realm.Configuration(
        schemaVersion: 8,
        migrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 8 {
                // 미션 1,2,3에 대한 T/F 추가
            }
        }
    )
    Realm.Configuration.defaultConfiguration = config
}

