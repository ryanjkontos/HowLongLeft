//
//  EventNotificationScheduler.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 4/2/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import UserNotifications

class EventNotificationScheduler: EventPoolUpdateObserver {
    
    let contentGenerator = HLLNNotificationContentGenerator()
    
    func eventPoolUpdated() {
        self.scheduleNotificationsForUpcomingEvents()
    }
    
    
    static var shared = EventNotificationScheduler()
    
    var delegates = [NotificationAccessDelegate]()
    
    var hasPermission = false
    var permissionFalseBecauseUnknown = false
    
    init() {
        HLLEventSource.shared.addEventPoolObserver(self)
        getAccess()
    }
    
    func getAccess() {
  
          let center = UNUserNotificationCenter.current()
            // Request permission to display alerts and play sounds.
            
            center.getNotificationSettings(completionHandler: { settings in
                
                if settings.authorizationStatus == .notDetermined {
                    self.permissionFalseBecauseUnknown = true
                } else {
                    self.permissionFalseBecauseUnknown = false
                }
                
            })
            
        
        if HLLDefaults.notifications.doneNotificationOnboarding == false {
            return
        }
        
        if HLLEventSource.shared.neverUpdatedEventPool {
            return
        }
    
        
        center.requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            
           let previous = self.hasPermission
                
            self.hasPermission = granted
                
            if self.hasPermission != previous {
                EventNotificationScheduler.shared.delegates.forEach { $0.notificationAccessState(granted) }
            }
            
        }
        
    }
    
    func sendTestNoto() {
        
        if let event = HLLEventSource.shared.getTimeline().first {
        
        var info = [AnyHashable:Any]()
        info["eventidentifier"] = event.persistentIdentifier
            
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = info
        notificationContent.sound = .default

        notificationContent.title = "Test Notification"
       
        notificationContent.subtitle = "For: \(event.title)"
      
        let calendar = Calendar.current
            let time = calendar.dateComponents([.hour, .minute, .second, .day, .month, .year], from: CurrentDateFetcher.currentDate.addingTimeInterval(2))
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        let uuidString = "Scheduled \(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: notificationContent, trigger: trigger)
        
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
        
            
        }
        
    }
    
    func scheduleNotificationsForUpcomingEvents() {
        
        if HLLDefaults.notifications.enabled == false {
            return
        }
        
        if HLLDefaults.notifications.doneNotificationOnboarding == false {
            return
        }
        
        if HLLEventSource.shared.neverUpdatedEventPool {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            
        let previous = self.hasPermission
            
        self.hasPermission = granted
            
        if self.hasPermission != previous {
            EventNotificationScheduler.shared.delegates.forEach { $0.notificationAccessState(granted) }
        }
            
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            if granted == true, HLLDefaults.notifications.enabled {
              
                let events = HLLEventSource.shared.getTimeline().sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
                
                let items = self.contentGenerator.generateNotificationContentItems(for: events)
                self.scheduleNotificationsFor(content: items)
            
            }
        
            }
            
        }
        
        
    }
    
    private func scheduleNotificationsFor(content items: [HLLNotificationContent]) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            
            for request in requests {
                
                if request.identifier.contains(text: "Scheduled") {
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    
                }
                
            }
            
        })
        
        for item in items {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = item.userInfo
        notificationContent.sound = .default
        
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
        let uuidString = "Scheduled \(UUID().uuidString)"
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: notificationContent, trigger: trigger)
        
        if item.date.timeIntervalSince(CurrentDateFetcher.currentDate) > 0 {
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in })
        }
            
        }
    }
    
    
}

protocol NotificationAccessDelegate {
    
    func notificationAccessState(_ state: Bool)
    
}
