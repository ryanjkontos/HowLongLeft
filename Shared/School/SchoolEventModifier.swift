//
//  SchoolEventModifier.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolEventModifier {
  
    func modify(events: [HLLEvent], addBreaks: Bool) -> [HLLEvent] {
        
        let magdaleneEventTitleShortener = EventTitleShortener()
        
        let timeAdjuster = EventTimeAdjuster()
        let periods = MagdalenePeriods()
        let breaks = MagdaleneBreaks()
        let tuesdayEvents = MagdaleneTuesdayEvents()
        
        
        var returnArray = [HLLEvent]()
            
        switch SchoolAnalyser.schoolMode {
        
        case .Magdalene:
            
            var tempArray = events
            
            
            tempArray = timeAdjuster.adjustTime(events: tempArray)
            
            if addBreaks {
            tempArray.append(contentsOf: breaks.getBreaks(events: tempArray))
            tempArray.append(contentsOf: tuesdayEvents.getTuesdayEvents(events: tempArray))
            }
            
            
            tempArray = periods.magdalenePeriodFor(events: tempArray)
            
            if HLLDefaults.magdalene.useSubjectNames {
            tempArray = magdaleneEventTitleShortener.shortenTitle(events: tempArray)
            }
           
            returnArray = tempArray
            
        default:
            
            returnArray = events
        
        }
        
        return returnArray
        
    }
    
}
