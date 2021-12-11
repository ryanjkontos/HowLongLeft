//
//  HLLNTrigger.swift
//  How Long Left
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNTrigger {
    
    internal init(type: HLLNTriggerType, value: Int) {
        self.type = type
        self.value = value
    }
    
    let type: HLLNTriggerType
    let value: Int
    
    func getTypeString() -> String {
        
        switch type {
            
        case .timeInterval(.timeRemaining):
            return "Time Remaining"
        case .timeInterval(.timeUntil):
            return "Time Until"
        case .percentageComplete:
            return "Percentage Complete"
            
        }
        
    }
    
    func getDescriptionString() -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        let durationString = formatter.string(from: TimeInterval(value))!
        
        switch type {
            
        case .timeInterval(.timeRemaining):
            return "An event has \(durationString) remaining"
        case .timeInterval(.timeUntil):
            return "There's \(durationString) until an event starts"
        case .percentageComplete:
            return "An event is \(String(value))% complete"
            
        }
        
        
        
        
    }
    
}
