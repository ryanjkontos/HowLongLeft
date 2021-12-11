//
//  MacNotificationDeliveryHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 17/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UserNotifications

class MacNotificationDeliveryHandler {
    
    static var shared = MacNotificationDeliveryHandler()
    
    func deliver(_ notificationContent: HLLNotificationContent) {
        
        if #available(OSX 10.14, *) {
            
            let content = UNMutableNotificationContent()
            
            if let sound = HLLDefaults.notifications.soundName {
            
                content.sound = UNNotificationSound(named: UNNotificationSoundName(sound))
            }
            
            if let safeTitle = notificationContent.title {
                content.title = safeTitle
            }
            
            if let safeSubtitle = notificationContent.subtitle {
                content.subtitle = safeSubtitle
            }
                
            if let safeBody = notificationContent.body {
                content.body = safeBody
            }
            
        
            
            let calendar = Calendar.current
            let time = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: Date())
            let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
            let uuidString = "\(UUID().uuidString)"
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
            
        } else {
            
            let notification = NSUserNotification()
            notification.title = notificationContent.title
            notification.subtitle = notificationContent.subtitle
            notification.informativeText = notificationContent.body
            notification.identifier = ""
            notification.soundName = HLLDefaults.notifications.soundName
            NSUserNotificationCenter.default.deliver(notification)
            
        }
        
        
    }
    
    
    
    
}
