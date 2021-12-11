//
//  MilestoneNotifications.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class MilestoneNotificationGenerator {
    
    let countdownStringGenerator = CountdownStringGenerator()
    let upcomingEventStringGenerator = UpcomingEventStringGenerator()
    
    
    func sendNotificationFor(milestone: Int, event: HLLEvent) {
        
       let upcomingEventText = upcomingEventStringGenerator.generateNextEventString(upcomingEvents: HLLEventSource.shared.getUpcomingEventsToday())
        
        let notification = NSUserNotification()
        
        notification.soundName = HLLDefaults.notifications.soundName
        
        if milestone == 0 {
            
            notification.title = "\(event.title) is done."
            
        } else {
            
            let item = countdownStringGenerator.generateCountdownTextFor(event: event, showEndTime: false)
            notification.title = item.mainText
            
            if let percent = item.percentageText {
                
                
                notification.subtitle = "(\(percent) done)"
                
                
  
                
                
                
                
            }
            
        }
        
        notification.informativeText = upcomingEventText
        
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    func sendNotificationFor(percentage: Int, event: HLLEvent) {
        
        let upcomingEventText = upcomingEventStringGenerator.generateNextEventString(upcomingEvents: HLLEventSource.shared.getUpcomingEventsToday())
        
        let notification = NSUserNotification()
        notification.soundName = HLLDefaults.notifications.soundName
        
        notification.title = "\(event.title) is \(percentage)% done."
        notification.subtitle = "(\(countdownStringGenerator.generateCountdownTextFor(event: event).justCountdown) left)"
        notification.informativeText = upcomingEventText
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    func sendStartingNotification(for event: HLLEvent) {
        
        let upcomingEventText = upcomingEventStringGenerator.generateNextEventString(upcomingEvents: HLLEventSource.shared.getUpcomingEventsToday())
        
        let notification = NSUserNotification()
        notification.title = "\(event.title) is starting now."
        notification.soundName = HLLDefaults.notifications.soundName
        notification.informativeText = upcomingEventText
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    
}
