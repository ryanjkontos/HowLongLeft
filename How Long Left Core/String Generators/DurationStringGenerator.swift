//
//  DurationStringGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class DurationStringGenerator {
    
    func generateDurationString(for interval: TimeInterval) -> String {
        
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
        
        return formatter.string(from: interval)!
        
    }
    
}
