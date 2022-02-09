//
//  HLLBackgroundTasks.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 9/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import BackgroundTasks

class HLLBackgroundTasks {
    
    static var shared = HLLBackgroundTasks()

    static let widgetTaskID = "com.ryankontos.How-Long-Left.widgetUpdateTask"
    
    func scheduleAppRefresh() {
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let request = BGAppRefreshTaskRequest(identifier: HLLBackgroundTasks.widgetTaskID)
        request.earliestBeginDate = Date().addingTimeInterval(15*60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled app refresh")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
            
        
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        runBackgroundTasks()
        task.setTaskCompleted(success: true)
    }
    
    func runBackgroundTasks() {
        let count = HLLDefaults.defaults.integer(forKey: "BGCount")+1
        HLLDefaults.defaults.set(count, forKey: "BGCount")
        WidgetUpdateHandler.shared.updateWidget(background: true)
    }
    
    
}
