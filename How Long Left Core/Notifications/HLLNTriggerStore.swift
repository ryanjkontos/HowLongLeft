//
//  HLLNTriggerStore.swift
//  How Long Left
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNTriggerStore {
    
    var triggers = [HLLNTrigger]()
    
    init() {
        updateTriggers()
    }
    
    func updateTriggers() {
        
        var triggers = [HLLNTrigger]()
        
        var timeUntilTriggers = [HLLNTrigger]()
        
        for timeUntilValue in HLLNTriggerFetcher.shared.getTimeUntilTriggers() {
            timeUntilTriggers.append(HLLNTrigger(type: .timeInterval(.timeUntil), value: timeUntilValue))
        }
        
        triggers.append(contentsOf: timeUntilTriggers.sorted(by: { $0.value < $1.value }))
        
        var timeRemainingTriggers = [HLLNTrigger]()
        
        for timeRemainingValue in HLLNTriggerFetcher.shared.getTimeRemainingTriggers() {
            timeRemainingTriggers.append(HLLNTrigger(type: .timeInterval(.timeRemaining), value: timeRemainingValue))
        }
        
        triggers.append(contentsOf: timeRemainingTriggers.sorted(by: { $0.value < $1.value }))
        
        var percentageTriggers = [HLLNTrigger]()
        
        for percentageValue in HLLNTriggerFetcher.shared.getPercentageTriggers() {
            percentageTriggers.append(HLLNTrigger(type: .percentageComplete, value: percentageValue))
        }

        triggers.append(contentsOf: percentageTriggers.sorted(by: { $0.value < $1.value }))
        
      //  print("There are \(triggers.count) triggers")
        self.triggers = triggers
        
    }
    
    func deleteTrigger(_ trigger: HLLNTrigger) {
        
        switch trigger.type {
          
        case .timeInterval(.timeUntil):
            
            HLLDefaults.notifications.startsInMilestones.removeAll { $0 == trigger.value }
            
        case .timeInterval(.timeRemaining):
            
            HLLDefaults.notifications.milestones.removeAll { $0 == trigger.value }
            
        case .percentageComplete:
            
            print("Deleting percentage trigger \(trigger.value)")
            
            HLLDefaults.notifications.Percentagemilestones.removeAll { $0 == trigger.value }
            
        }
        
    }
    
}
