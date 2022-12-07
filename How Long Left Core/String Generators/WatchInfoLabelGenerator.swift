//
//  WatchInfoLabelGenerator.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 17/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class WatchInfoLabelGenerator {
    
    static func getLabelFor(event: HLLEvent, at date: Date) -> String? {
        
        let percentageText = "\(Int(event.completionFraction(at: date)*100))%"
        
        if let location = event.location, HLLDefaults.watch.largeHeaderLocation {
            
            if HLLDefaults.watch.showPercentage, event.completionStatus(at: date) == .current {
                return "\(location) | \(percentageText)"
            } else {
                return "\(location)"
            }
            
        }
        
        if HLLDefaults.watch.showPercentage, event.completionStatus(at: date) == .current {
            return "\(percentageText) Done"
        }
        
        return nil
        
    }
    
}
