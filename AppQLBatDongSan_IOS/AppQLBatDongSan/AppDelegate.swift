//
//  AppDelegate.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Reachability
import RealmSwift
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var hasInternet = false
    private var reachability : Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Map configure
        GMSServices.provideAPIKey("AIzaSyCc9t6g4kAeg325G0j4_OW9k3vVoyFcW1o")
        GMSPlacesClient.provideAPIKey("AIzaSyCc9t6g4kAeg325G0j4_OW9k3vVoyFcW1o")
        // Check connect internet
        listenNetworkStatus()
        
        // Setup HUD Progress
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.15))
        // Migration Realm
        let realmVersion = RealmSetting.schemaVersion
        let config = Realm.Configuration(schemaVersion: realmVersion, migrationBlock: { (migration, oldSchemaVersion) in
            if oldSchemaVersion < realmVersion {
                // Nothing to do
                // Auto migration
            }
        })
        Realm.Configuration.defaultConfiguration = config
        
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Start app
        let splash = SplashViewController()
        let nav = UINavigationController(rootViewController: splash)
        nav.isNavigationBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func listenNetworkStatus() {
        reachability = Reachability()
        reachability?.whenReachable = {[weak self]reachability in
            if !(self?.hasInternet ?? false) {
                // Reconnect
                self?.hasInternet = true
                NoticeGroup.shared.closeAllNoticeNetWork()
                let type = reachability.connection == .wifi ? "Wifi" : "Online"
                Notice.make(type: .Success, content: String(format: "Switch To Network Mode Format", type), isNetWork: true).show()
                print("Reachable via \(type)")
            }
        }
        reachability?.whenUnreachable = {[weak self] _ in
            print("Not reachable")
            self?.hasInternet = false
            NoticeGroup.shared.closeAllNoticeNetWork()
            Notice.make(type: .Warning, content: String(format: "Switch To Network Mode Format", "OfflineMode"), isNetWork: true).show()
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print(error)
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

