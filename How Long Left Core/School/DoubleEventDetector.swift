//
//  DoubleEventDetector.swift
//  How Long Left
//
//  Created by Ryan Kontos on 22/10/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
/*
class DoubleEventDetector {
    
    func detectDoublesIn(events: [HLLEvent]) -> [HLLEvent] {
        
       /* if HLLDefaults.magdalene.doDoubles == false {
            return events
        } */
        
        var returnArray = [HLLEvent]()
        
        var ignoreIndexes = [Int]()
        
        for (index, event) in events.enumerated() {
            
            let newEvent = event
            
            let nextIndex = index+1
            
            if ignoreIndexes.contains(index) != true {
                
                if events.indices.contains(nextIndex) {
                    
                    inner: for (Doubleindex, eventTwo) in events.enumerated() {
                        
                        if eventTwo.startDate == event.endDate, eventTwo.title == event.title {
            
                            newEvent.title = "Double \(newEvent.title)"
                            newEvent.isDouble = true
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
*/
