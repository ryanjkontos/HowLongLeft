//
//  ExtensionDelegate.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 15/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import UserNotifications

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    
    let handler = NameConversionsDownloader()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.sound)
    }
    
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        
       
        
        DispatchQueue.global(qos: .default).async {
            
            
        WatchSessionManager.sharedManager.startSession()
        HLLDefaultsTransfer.shared.addTransferHandler(WatchSessionManager.sharedManager)
    
            self.handler.downloadNames()

        }
            
    }

  

    func applicationDidBecomeActive() {
        

        DispatchQueue.global(qos: .default).async {
        HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        ComplicationUpdateHandler.shared.updateComplication()
        }
    
    }

    func applicationWillResignActive() {
        
        DispatchQueue.global(qos: .default).async {
        HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        ComplicationUpdateHandler.shared.updateComplication()
        }
        
    }
    
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        
        DispatchQueue.main.async {
            
            // print("Trig9")
            
        if userInfo?[CLKLaunchedTimelineEntryDateKey] as? Date != nil {
            // Handoff from complication
            ComplicationUpdateHandler.shared.updateComplication()
            
        }
        else {
            // Handoff from elsewhere
        }
        
        
        }
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                
                ComplicationUpdateHandler.shared.updateComplication()
                
                let bh = BackgroundUpdateHandler(); bh.scheduleComplicationUpdate()
                
                
                
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
                
                
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
            
            }
            
        
        
    }

}
