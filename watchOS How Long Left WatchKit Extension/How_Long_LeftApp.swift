//
//  How_Long_LeftApp.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import SwiftUI
import WatchKit


@main
struct How_Long_LeftApp: App {
    
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    
    let timelineGen = HLLTimelineGenerator(type: .complication)
    
    init() {
        HLLEventSource.shared.updateEventPool()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    
            }
            
        }
    }
    
    
}


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
    
    func applicationDidFinishLaunching() {
        
       // ComplicationController.updateComplications(forced: true)
        
    }
    
    func applicationDidBecomeActive() {
        print("Triggering complication update...")
        ComplicationController.updateComplications(forced: false)
        scheduleNextComplicationUpdateTask()
        
        
    }
    
    func applicationWillResignActive() {
        print("Triggering complication update...")
        ComplicationController.updateComplications(forced: false)
        scheduleNextComplicationUpdateTask()
    }
    
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        
        if let _ = userInfo?["CLKLaunchedComplicationIdentifierKey"] {
            print("Launched from complication")
            
            ExtensionDelegate.complicationLaunchDelegate?.launchedFromComplication()
        }
        
        
    }
    
    
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        for backgroundTask in backgroundTasks {

            
            
            print("Handling Background Task")
            
            ComplicationLogger.log("Running background task: \(backgroundTask.userInfo?.description ?? "No UserInfo")")
            
            ComplicationController.updateComplications(forced: false)
            scheduleNextComplicationUpdateTask()
            backgroundTask.setTaskCompletedWithSnapshot(false)
        }
        
    }
    
    func scheduleNextComplicationUpdateTask() {
        
        if let last = HLLDefaults.watch.lastScheduledUpdateDate {
            if last.timeIntervalSinceNow > 0 {
                print("Not scheduling update because another one is scheduled")
                return
            }
        }
        
        let nextRefreshDate = Date().addingTimeInterval(20*60)
        let userInfo = ["type":"complication"] as! (NSSecureCoding & NSObjectProtocol)
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextRefreshDate, userInfo: userInfo, scheduledCompletion: { error in
             
            if let error = error {
                //ComplicationLogger.log("Error Scheduling Update: \(error.localizedDescription)")
                print("Error Scheduling Complication Update: \(error.localizedDescription)")
            } else {
                print("Scheduled Complication Update")
               // ComplicationLogger.log("Scheduled update for \(nextRefreshDate.formattedTime(seconds: true))")
                HLLDefaults.watch.lastScheduledUpdateDate = nextRefreshDate
            }
            
        })
        
    }
    
}
