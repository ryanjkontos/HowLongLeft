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
        
        
            BGTaskScheduler.shared.register(forTaskWithIdentifier: self.taskID, using: nil) { task in
                self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        scheduleAppRefresh()
    }


}

extension AppDelegate {
    
    func scheduleAppRefresh() {
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = Date().addingTimeInterval(15*60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
            
        
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {

        scheduleAppRefresh()
        
     
        let count = HLLDefaults.defaults.integer(forKey: "BGCount")+1
        HLLDefaults.defaults.set(count, forKey: "BGCount")
        
        WidgetUpdateHandler.shared.updateWidget(background: true)
        
        
        
        task.setTaskCompleted(success: true)
        
    }

    
}

