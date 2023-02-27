//
//  MacEventNotificationScheduler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit
import UserNotifications

class MacEventNotificationScheduler: EventSourceUpdateObserver {
    
    static var shared: MacEventNotificationScheduler!
    
    let contentGenerator = HLLNNotificationContentGenerator()
    
    var hasPermission = false
    var permissionFalseBecauseUnknown = false
    
    init() {
        HLLEventSource.shared.addeventsObserver(self)
        getAccess()
        //scheduleNotificationsForUpcomingEvents()
    }
    
    func getAccess() {
        
        if #available(OSX 10.14, *) {
            let center = UNUserNotificationCenter.current()
            
            center.getNotificationSettings(completionHandler: { settings in
            
            if settings.authorizationStatus == .notDetermined {
                self.permissionFalseBecauseUnknown = true
            } else {
                self.permissionFalseBecauseUnknown = false
            }
                      
            })
              
              if HLLEventSource.shared.neverUpdatedevents {
                  return
              }
              
              center.requestAuthorization(options: [.alert, .sound, .badge])
              { (granted, error) in
                  
                 let previous = self.hasPermission
                      
                  self.hasPermission = granted
                      
               // // print("Noto auth: \(granted)")
                
                  if granted != previous {
                    self.scheduleNotificationsForUpcomingEvents()
                  }
                  
              }
            
        } else {
            self.hasPermission = true
            self.scheduleNotificationsForUpcomingEvents()
        }
        
          
      }
    
    func scheduleNotificationsForUpcomingEvents() {
        
        return
        
        DispatchQueue.global(qos: .background).async {
            
           
            
            self.getAccess()
            
            self.removeScheduledNotifications()
            
            if HLLDefaults.notifications.enabled == false {
                return
            }
            
            if let date = HLLDefaults.statusItem.hideEventsOn {
                if date.startOfDay() == Date().startOfDay() {
                    return
                }
            }
        
      
            
            let events = HLLEventSource.shared.events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
            let items = self.contentGenerator.generateNotificationContentItems(for: events)
        
            var scheduledIDS = [String]()
            
            for item in items {
            
                let notificationIdentifier = item.event!.persistentIdentifier
                scheduledIDS.append(notificationIdentifier)
                
                if item.date.timeIntervalSince(CurrentDateFetcher.currentDate) > 0 {
            
                    if #available(OSX 10.14, *) {
                
                        let notificationContent = UNMutableNotificationContent()
                        notificationContent.userInfo = item.userInfo
                        if HLLDefaults.notifications.sounds {
                        notificationContent.sound = .default
                        }
                        
                        if let title = item.title {
                            notificationContent.title = title
                        }
                            
                        if let subtitle = item.subtitle {
                            notificationContent.subtitle = subtitle
                        }
                            
                        if let body = item.body {
                            notificationContent.body = body
                        }
                        
                        let calendar = Calendar.current
                        let time = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: item.date)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
                        let uuidString = UUID()
                        let request = UNNotificationRequest(identifier: uuidString.uuidString, content: notificationContent, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
                        
                     //   // print("Scheduling noto for \(item.event?.title) \(item.date)")
                        
                        
                    } else {
                
                        let notification = NSUserNotification()
                        notification.deliveryDate = item.date
                        notification.soundName = HLLDefaults.notifications.soundName
                        notification.title = item.title
                        notification.subtitle = item.subtitle
                        notification.informativeText = item.body
                        notification.identifier = notificationIdentifier
                        NSUserNotificationCenter.default.scheduleNotification(notification)
                        
                        // print("Scheduling noto for \(item.date)")
                
                    }
                
                }
            
            }
            // print("Scheduled \(items.count) notifications!")
            
            HLLDefaults.defaults.set(scheduledIDS, forKey: "ScheduledEventNotifications")
            
        }
        
    }
    
    func removeScheduledNotifications() {
        
        if #available(OSX 10.14, *) {
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            
        } else {
            
            let center = NSUserNotificationCenter.default
    
            for notification in center.scheduledNotifications {
                center.removeScheduledNotification(notification)
            }
            
        }
        
    }
    
    func eventsUpdated() {
        scheduleNotificationsForUpcomingEvents()
    }
    
    
}
