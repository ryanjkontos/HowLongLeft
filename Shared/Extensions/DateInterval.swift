//
//  DateInterval.swift
//  How Long Left
//
//  Created by Ryan Kontos on 24/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

extension DateInterval {
    
    func datesInInterval(seperatedBy seperationInterval: TimeInterval) -> [Date] {
        
        var dates = [Date]()
        
        var current = self.start
        
        while current < self.end {
            
            dates.append(current)
            current = current.addingTimeInterval(seperationInterval)
            
        }
        
        dates.append(self.end)
        
        return dates
        
    }
    
    
    func getShortIntervalString() -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.minute, .hour, .day]

        return formatter.string(from: self.duration)!
           
        
        
    }
    
}
