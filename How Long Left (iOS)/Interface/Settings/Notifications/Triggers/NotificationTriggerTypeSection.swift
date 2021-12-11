//
//  NotificationTriggerTypeSection.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 30/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class NotificationTriggerTypeSection {
    
    var triggers = [HLLNotificationTrigger]()
    var type: HLLNotificationTriggerType
    var header: String
    
    internal init(type: HLLNotificationTriggerType, header: String, triggers: [HLLNotificationTrigger]) {
        self.type = type
        self.header = header
        self.triggers = triggers
    }
}
