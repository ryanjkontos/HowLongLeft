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
        
        if let intervalString = HLLDefaults.defaults.string(forKey: "NextWidgetUpdate"), let interval = TimeInterval(intervalString) {
            
            if Date(timeIntervalSinceReferenceDate: interval) > Date() {
                print("Too soon bro")
                return
            }
            
        }
        
        let nextUpdate = Date().addingTimeInterval(2*60)
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let request = BGAppRefreshTaskRequest(identifier: HLLBackgroundTasks.widgetTaskID)
        request.earliestBeginDate = nextUpdate

        
        do {
            try BGTaskScheduler.shared.submit(request)
            HLLDefaults.defaults.set(String(nextUpdate.timeIntervalSinceReferenceDate), forKey: "NextWidgetUpdate")
            print("Scheduled app refresh")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
            
      
        
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        
        scheduleAppRefresh()
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        
        
        let operation = WidgetUpdateOperation()
        operation.background = true
        operation.completionBlock = { task.setTaskCompleted(success: operation.isFinished) }
        
    
        
        task.expirationHandler = {
            
            
            queue.cancelAllOperations()
            self.scheduleAppRefresh()
            
        }
        
        let count = HLLDefaults.defaults.integer(forKey: "BGCount")+1
        HLLDefaults.defaults.set(count, forKey: "BGCount")
        
        queue.addOperation(operation)
        
       
        
        
    }
    
    func runBackgroundTasks() {
        
    }
    
    
}

class WidgetUpdateOperation: Operation {
    
    var background = false
    
    override func main() {
        
        
        WidgetUpdateHandler.shared.updateWidget(background: background)
        
    }
}
