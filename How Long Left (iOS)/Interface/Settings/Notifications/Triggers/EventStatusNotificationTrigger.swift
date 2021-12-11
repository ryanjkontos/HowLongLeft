//
//  EventStatusNotificationTrigger.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 30/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class EventStatusNotificationTrigger: HLLNotificationTrigger {
    
    var value: Int?
    var type: HLLNotificationTriggerType
    var userString: String
    var removeTriggerAction: (() -> Void)
    var eventStatusTriggerType: EventStatusTrigger
    
    init(eventStatusTrigger trigger: EventStatusTrigger) {
        
        self.value = nil
        type = .EventStatus
        eventStatusTriggerType = trigger
        
        switch trigger {
            
        case .Starts:
            userString = "Event Start"
            
            removeTriggerAction = { HLLDefaults.notifications.startNotifications = false }
            
        case .Ends:
            userString = "Event End"
            
            removeTriggerAction = { HLLDefaults.notifications.endNotifications = false }

        }
        
    }
    
    func isEnabled() -> Bool {
        
        switch eventStatusTriggerType {
            
        case .Starts:
            
            return HLLDefaults.notifications.startNotifications
            
            
        case .Ends:
            
            return HLLDefaults.notifications.endNotifications

        }
        
    }
    
    
}
