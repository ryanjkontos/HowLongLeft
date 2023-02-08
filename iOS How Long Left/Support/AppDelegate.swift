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
import Defaults
import Zephyr
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let wc = HLLWCManager()
    var hwFinder: HWEventFinder?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize and configure objects and services
        
    
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }
        
        
        
        initializeDataModel()
        
        //HLLEventSource.shared = HLLEventSource()
        
        initializeHWEventFinder()
        

       
        
        initializeOneSignal(with: launchOptions)
        registerBackgroundTask()
        
        // Set default values
        HLLDefaults.general.showAllDay = true
        
        // Update events
        HLLEventSource.shared.updateEvents()
        
        return true
    }
    
    // MARK: Initialization
    

    
    private func initializeDataModel() {
        HLLDataModel.shared = HLLDataModel()
    }
    
    private func initializeHWEventFinder() {
        HWEventFinder.shared = HWEventFinder(onEventFound: { value in
            print("HWEventFinder: \(value)")
            OneSignal.disablePush(!value)
            if value {
                OneSignal.sendTag("WantsHWShifts", value: "true")
                OneSignal.promptForPushNotifications(userResponse: { accepted in })
            } else {
                OneSignal.sendTag("WantsHWShifts", value: "false")
               
            }
            
            let HWCategory = UNNotificationCategory(identifier: "HWShifts", actions: [], intentIdentifiers: [], options: [.hiddenPreviewsShowTitle])
            UNUserNotificationCenter.current().setNotificationCategories([HWCategory])
        })
    }
    
    private func initializeOneSignal(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("6d1e33c8-d94f-4e2d-8579-981dfbfb1f09")
        OneSignal.setExternalUserId(getUserNotificationID())
    }
    
    private func registerBackgroundTask() {
        let task = BGTaskScheduler.shared.register(forTaskWithIdentifier: HLLBackgroundTasks.widgetTaskID, using: nil) { task in
            HLLBackgroundTasks.shared.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        
        if task {
            HLLDefaults.defaults.set(true, forKey: "RegisteredWidgetTask")
        }
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
    
    // MARK: Helper methods
    
    func getUserNotificationID() -> String {
        let key = "RemoteNotificationsUserID"
        let defaults = HLLDefaults.defaults
        // Check if the identifier already exists in the app's defaults store
        guard let id = defaults.string(forKey: key) else {
            // Generate a new identifier using the UUID class and save it to the app's defaults store
            let id = "HLLiOS_\(UUID().uuidString)"
            defaults.set(id, forKey: key)
            
            // Return the new identifier
            return id
        }
        
        // If the identifier already exists, simply return it
        return id
    }
}
