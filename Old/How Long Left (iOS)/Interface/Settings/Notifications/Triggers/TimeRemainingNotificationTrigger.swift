//
//  TimeRemainingNotificationTrigger.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 30/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class TimeRemainingNotificationTrigger: HLLNotificationTrigger {
    
    var value: Int?
    var type: HLLNotificationTriggerType
    var userString: String
    var removeTriggerAction: (() -> Void)
    
    init(seconds: Int) {
        
        value = seconds
        type = .TimeRemaining
        let min = seconds/60
        
        var minText = "Minutes"
        if min == 1 {
            minText = "Minute"
        }
        
        userString = "\(min) \(minText) Remaining"
        removeTriggerAction = { HLLDefaults.notifications.milestones.removeAll { $0 == seconds } }
        
    }
    
    func isEnabled() -> Bool {
        
        return HLLDefaults.notifications.milestones.contains(value!)
        
    }
    
}
