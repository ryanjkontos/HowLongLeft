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
                    .onAppear {
                        print("Triggering complication update...")
                        ComplicationController.updateComplications()
                    }
                    .onDisappear {
                        print("Triggering complication update...")
                        ComplicationController.updateComplications()
                    }
            }
            
        }
    }
    
    
}


class ExtensionDelegate: NSObject, ObservableObject, WKExtensionDelegate {
      
    static var complicationLaunchDelegate: EventsListView?
    
    func applicationDidBecomeActive() {
        print("Triggering complication update...")
        ComplicationController.updateComplications()
        
        
    }
    
    func applicationWillResignActive() {
        print("Triggering complication update...")
        ComplicationController.updateComplications()
    }
    
    func handleUserActivity(_ userInfo: [AnyHashable : Any]?) {
        
        if let _ = userInfo?["CLKLaunchedComplicationIdentifierKey"] {
            print("Launched from complication")
            
            ExtensionDelegate.complicationLaunchDelegate?.launchedFromComplication()
        }
        
        
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        
        for backgroundTask in backgroundTasks {
           
           
            backgroundTask.setTaskCompletedWithSnapshot(false)
        }
        
    }
    
    func scheduleNextComplicationUpdateTask() {
        
        let nextRefreshDate = Date().addingTimeInterval(30*60)
       // let userInfo = ["type":"complication"]
        
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: nextRefreshDate, userInfo: nil, scheduledCompletion: { error in
            self.scheduleNextComplicationUpdateTask()
        })
        
    }
    
}
