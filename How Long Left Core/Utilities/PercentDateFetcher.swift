//
//  PercentDateFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 30/11/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class PercentDateFetcher {
    
    func fetchPercentDates(for event: HLLEvent, every percent: Int) -> Set<Date> {
        
        var returnDates = Set<Date>()
        let percentInterval = event.duration/100
        var current = event.startDate
        var index = 0
        
        while event.endDate > current {
            if index.isMultiple(of: percent) {
                returnDates.insert(current)
            }
            
            current.addTimeInterval(percentInterval)
            index += 1
        }
        
        return returnDates
    }
    
    
}
