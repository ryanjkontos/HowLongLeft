//
//  PercentageNotificationTrigger.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 30/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class PercentageNotificationTrigger: HLLNotificationTrigger {
    
    var value: Int?
    var type: HLLNotificationTriggerType
    var userString: String
    var removeTriggerAction: (() -> Void)
    
    init(percentage: Int) {
        
        value = percentage
        type = .Percentage
        userString = "\(percentage)% Complete"
        removeTriggerAction = { HLLDefaults.notifications.Percentagemilestones.removeAll { $0 == percentage } }
        
    }
    
    func isEnabled() -> Bool {
        
        return HLLDefaults.notifications.Percentagemilestones.contains(value!)
        
    }
    
}
