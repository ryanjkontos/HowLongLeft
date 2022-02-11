//
//  AppDelegate.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 21/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  //  let communicationManager = CommunicationManager()
    
    let taskID = "com.ryankontos.How-Long-Left.widgetUpdateTask"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

       
        
        Store.shared = Store()
        
        HLLDefaults.general.showAllDay = true
        HLLEventSource.shared.updateEventPool()
        
      // print("ComplicationHash: \(HLLDefaults.defaults.string(forKey: "ComplicationHash") ?? "No Value")")
        
        
        if HLLDefaults.defaults.bool(forKey: "RegisteredWidgetTask") == false {
        
        let task = BGTaskScheduler.shared.register(forTaskWithIdentifier: HLLBackgroundTasks.widgetTaskID, using: nil) { task in
            HLLBackgroundTasks.shared.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
            
            print("Task scheduled: \(task)")
            
            HLLDefaults.defaults.set(true, forKey: "RegisteredWidgetTask")
            
        }
        
       
        
        
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

