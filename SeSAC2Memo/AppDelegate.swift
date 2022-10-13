//
//  AppDelegate.swift
//  SeSAC2Memo
//
//  Created by Y on 2022/08/31.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        aboutRealmMigration()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func aboutRealmMigration() {
        //마이그레이션 필요하다면 기존 렘 삭제
        //let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            //컬럼, 테이블 단순 추가 삭제 경우 별도 코드 필요 x
            if oldSchemaVersion < 1 {
                
            }

            if oldSchemaVersion < 2 {
                
            }
            if oldSchemaVersion < 3 {
                
            }
            if oldSchemaVersion < 4 {
                
            }
            if oldSchemaVersion < 5 {
                
            }
            if oldSchemaVersion < 6 {
                
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
