//
//  HLLNCustomNotificationFilter.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNTriggerFetcher {
    
    static var shared = HLLNTriggerFetcher()
    
    func getTimeRemainingTriggers() -> [Int] {
        
        var milestones = HLLDefaults.notifications.milestones
        
        if !ProStatusManager.shared.isPro {
        
        milestones = milestones.filter({ value in
            
            if HLLDefaults.notifications.defaultMilestones.contains(value) {
                return false
            } else {
                return true
            }
            
        })
        
        
       
    }
        
        return milestones
        
    }
    
    func getTimeUntilTriggers() -> [Int] {
        
        var milestones = HLLDefaults.notifications.startsInMilestones
        
        if !ProStatusManager.shared.isPro {
            milestones.removeAll()
        }
        
        return milestones
        
    }
    
    func getPercentageTriggers() -> [Int] {
        
        var milestones = HLLDefaults.notifications.Percentagemilestones
        
        if !ProStatusManager.shared.isPro {
        
        milestones = milestones.filter({ value in
            
            if HLLDefaults.notifications.defaultPercentageMilestones.contains(value) {
                return false
            } else {
                return true
            }
            
        })
        
        
       
    }
        
        return milestones
        
    }
    
}
