//
//  DurationStringGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class DurationStringGenerator {
    
    func generateDurationString(for interval: TimeInterval, seconds: Bool = false) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        if interval >= TimeInterval.year {
            
            formatter.allowedUnits = [.year, .weekOfMonth]
            
        } else if interval >= TimeInterval.week {
            
            formatter.allowedUnits = [.day, .weekOfMonth]
            
        } else if interval >= TimeInterval.day {
            
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .abbreviated
            
        } else if interval >= TimeInterval.hour {
                
            formatter.allowedUnits = [.minute, .hour]
                
        } else {
                
            formatter.allowedUnits = [.minute]
                
        }
        
        if seconds {
            formatter.allowedUnits.insert(.second)
        }
        
        return formatter.string(from: interval)!
        
    }
    
}
