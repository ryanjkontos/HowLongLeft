//
//  UpcomingEventStringGenerator.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 21/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class UpcomingEventStringGenerator {
    
    func generateNextEventString(upcomingEvents: [HLLEvent], currentEvents: [HLLEvent], isForDoneNotification: Bool) -> (String?, String?) {
        
        var returnString: String?
        var returnLocation: String?
            
            if upcomingEvents.isEmpty == false {
                
                let nextEvent = upcomingEvents[0]
                
                var nextNonBreakEvent = nextEvent
                
                if currentEvents.isEmpty == false {
                    
                    if nextEvent.startDate.timeIntervalSince(CurrentDateFetcher.currentDate) < 1, isForDoneNotification == true {
                        
                        returnString = "\(nextEvent.title) is starting now"
                        
                        
                    } else {
                        
                        returnString = "\(nextEvent.title) starts next"
                        
                    }
                    
                    if nextEvent.title.containsAnyOfThese(Strings: ["Recess","Lunch"]), SchoolAnalyser.schoolMode == .Magdalene {
                        
                        if upcomingEvents.indices.contains(1) {
                     
                            let afterNextEvent = upcomingEvents[1] 
                            
                            nextNonBreakEvent = afterNextEvent
                            
                            returnString = "\(returnString!), then \(afterNextEvent.title)"
                            
                        
                        
                    }
                        
                    } else {
                        
                        if currentEvents.isEmpty == false {
                            
                            let currentEvent = currentEvents[0]
                            
                            if currentEvent.endDate != nextEvent.startDate {
                                returnString = "\(returnString!), at \(nextEvent.startDate.formattedTime())"
                            }
                            
                        }
                        
                    }
                    
                    if let nextEventLocation = nextNonBreakEvent.location {
                        
                        returnLocation = nextEventLocation
                        
                    }
                    
                } else {
                    
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.hour, .minute]
                    formatter.unitsStyle = .full
                    let timeUntilStartFormatted = formatter.string(from: nextEvent.startDate.timeIntervalSince(CurrentDateFetcher.currentDate)+60)!
                    
                    returnString = "\(nextEvent.title) starts in \(timeUntilStartFormatted)."
                    
                    if let nextEventLocation = nextEvent.location {
                        
                        returnLocation = nextEventLocation
                        
                    }
                    
                }
                
            } else {
                
                returnString = "No upcoming events."
                
            }
        
        
        return (returnString, returnLocation)
    }
    
    
    
}
