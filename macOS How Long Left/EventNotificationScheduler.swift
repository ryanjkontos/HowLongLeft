//
//  EventNotificationScheduler.swift
//  How Long Left
//
//  Created by Ryan Kontos on 26/7/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UserNotifications
import AppKit

class EventNotificationScheduler {
    
    var cal = EventDataSource()
    var hasPermission = true
    let schoolAnalyser = SchoolAnalyser()
    let countdownStringGen = CountdownStringGenerator()
    
    
    func scheduleNotificationsFor(events: [HLLEvent]) {
        
        DispatchQueue.main.async {
            
            let center = NSUserNotificationCenter.default
            
            for item in center.scheduledNotifications {
                center.removeScheduledNotification(item)
            }

            for event in events {
                    
                for milestone in HLLDefaults.notifications.milestones {
                        
                    let milestoneMin = milestone/60
                    let negativeMilestone = 0 - milestone
                    let date = event.endDate.addingTimeInterval(TimeInterval(negativeMilestone))
                    
                    if date.timeIntervalSinceNow >= 0 {
                    
                    let countdownTextData = self.countdownStringGen.generateCountdownTextFor(event: event, currentDate: date.addingTimeInterval(1))
                    
                    let notification = NSUserNotification()
                    
                    var notoTitle = countdownTextData.mainText
                    
                    if milestoneMin == 0 {
                        
                        notoTitle = "\(event.title) is done."
                        
                    } else {
                        
                        if let percent = countdownTextData.percentageText {
                        
                        notification.subtitle = "(\(percent) Done)"
                            
                        }
                        
                    }
                    
                    notification.title = notoTitle
                    notification.deliveryDate = date
                    
                    notification.actionButtonTitle = "Countdown Window"
                    notification.hasActionButton = true
                    
                    NSUserNotificationCenter.default.scheduleNotification(notification)
                    
                }
                    
                    for percentageMilestone in HLLDefaults.notifications.Percentagemilestones {
                        
                        let milestoneSecondsFromStart = Int(event.duration)/100*percentageMilestone
                        let date = event.startDate.addingTimeInterval(TimeInterval(milestoneSecondsFromStart))
                        
                        if date.timeIntervalSinceNow >= 0 {
                        
                        let notification = NSUserNotification()
                        notification.soundName = HLLDefaults.notifications.soundName
                        
                        notification.title = "\(event.title) is \(percentageMilestone)% done."
                        
                        notification.deliveryDate = date
                        NSUserNotificationCenter.default.scheduleNotification(notification)
                        }
                        
                    }
                    
                }
                    
            }
                
                
            
            
        }
        
        
    }
    
    
    func eventsNotStartedBy(date: Date, events: [HLLEvent]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        for event in events {
            
            if event.startDate.timeIntervalSince(date) > -1 {
                
                returnArray.append(event)
                
            }
            
        }
        
        return returnArray
    }
    
    
    
}
