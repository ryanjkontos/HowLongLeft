//
//  DoubleEventRemover.swift
//  How Long Left
//
//  Created by Ryan Kontos on 22/10/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//
import Foundation

class DoubleEventRemover {
    
    func removeDoublesIn(events: [HLLEvent]) -> [HLLEvent] {

        if !HLLDefaults.general.combineDoubles {
            return events
        }
        
        var returnArray = [HLLEvent]()
        var ignoreIndexes = [Int]()
        
        for (index, event) in events.enumerated() {
            
            var newEvent = event
            let nextIndex = index+1
            
            if ignoreIndexes.contains(index) != true {
                if events.indices.contains(nextIndex) {
                    inner: for (Doubleindex, eventTwo) in events.enumerated() {
                        if eventTwo.startDate == event.endDate, eventTwo.title == event.title {
                            newEvent.endDate = eventTwo.endDate
                            ignoreIndexes.append(Doubleindex)
                            break inner
                        }
                    }
                }
                returnArray.append(newEvent)
            }
        }
        
        return returnArray
        
    }
    
}
