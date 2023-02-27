//
//  ExtensionDelegate.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 1/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity
import UserNotifications
import WidgetKit

class ExtensionDelegate: NSObject, ObservableObject, WKExtensionDelegate {
      
    static var complicationLaunchDelegate: EventsListView?

    
    
    var compileDate: Date? {
        let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as? String ?? "Info.plist"
        if let infoPath = Bundle.main.path(forResource: bundleName, ofType: nil),
           let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath),
           let infoDate = infoAttr[FileAttributeKey.creationDate] as? Date
        { return infoDate }
        return nil
    }
    
    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()
    
    let wc = HLLWCManager()
    
    let stateReceiver = ComplicationStateManager()
    
    func applicationDidFinishLaunching() {
        
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }
        
        let HWCategory =
              UNNotificationCategory(identifier: "HWShifts",
              actions: [],
              intentIdentifiers: [],
                                     options: [])
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([HWCategory])
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(ubiquitousKeyValueStoreDidChange), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: HLLDefaults.cloudDefaults)
      //  HLLDefaults.cloudDefaults.synchronize()
        
        stateReceiver.updateForCloud()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            NicknameManager.shared.loadNicknames()
            
        })
        
        ComplicationController.updateComplications(forced: true)
        
    }
    
    @objc func ubiquitousKeyValueStoreDidChange() {
        
       // HLLDefaults.cloudDefaults.synchronize()
        stateReceiver.updateForCloud()
        
    }
    
    func applicationDidBecomeActive() {
        // print("Triggering complication update...")
        HLLEventSource.shared.shiftLoader.load()
        ComplicationController.updateComplications(forced: false)
        scheduleNextComplicationUpdateTask()
        
        Task {
          
            NicknameManager.shared.loadNicknames()
            ubiquitousKeyValueStoreDidChange()
            
        }
        
        
    }
    
    func applicationWillResignActive() {
        // print("Triggering complication update...")
        HLLEventSource.shared.shiftLoader.load()
        ComplicationController.updateComplications(forced: false)
        scheduleNextComplicationUpdateTask()
        
    }
    
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        
        if let _ = userInfo?["CLKLaunchedComplicationIdentifierKey"] {
            // print("Launched from complication")
            
            
            HLLEventSource.shared.shiftLoader.load()
        }
        
        
    }
    
    func completeBackgroundTasks() {
        guard !wcBackgroundTasks.isEmpty else { return }

        guard WCSession.default.activationState == .activated,
            WCSession.default.hasContentPending == false else { return }
        
        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }

        wcBackgroundTasks.removeAll()
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        for backgroundTask in backgroundTasks {

            
           
            if let refreshTask = backgroundTask as? WKWatchConnectivityRefreshBackgroundTask {
                
                wcBackgroundTasks.append(refreshTask)
                
            } else {
                
                // print("Handling Background Task")
                
                //ComplicationLogger.log("Running background task: \(backgroundTask.userInfo?.description ?? "No UserInfo")")
                
                
                
                ComplicationController.updateComplications(forced: false)
                scheduleNextComplicationUpdateTask()
                backgroundTask.setTaskCompletedWithSnapshot(false)
                
                
            }
        }
        
        completeBackgroundTasks()
        
    }
    
    func scheduleNextComplicationUpdateTask() {
        
        if let last = HLLDefaults.watch.lastScheduledUpdateDate {
            if last.timeIntervalSinceNow > 0 {
                // print("Not scheduling update because another one is scheduled")
                return
            }
        }
        
        let nextRefreshDate = Date().addingTimeInterval(20*60)
        let userInfo = ["type":"complication"] as! (NSSecureCoding & NSObjectProtocol)
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextRefreshDate, userInfo: userInfo, scheduledCompletion: { error in
             
            if let error = error {
                //ComplicationLogger.log("Error Scheduling Update: \(error.localizedDescription)")
                // print("Error Scheduling Complication Update: \(error.localizedDescription)")
            } else {
                // print("Scheduled Complication Update")
               // ComplicationLogger.log("Scheduled update for \(nextRefreshDate.formattedTime(seconds: true))")
                HLLDefaults.watch.lastScheduledUpdateDate = nextRefreshDate
            }
            
        })
        
    }
    
}
