//
//  EventTimeAdjuster.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class EventTimeAdjuster {
   
    static let shared = EventTimeAdjuster()
    
    func adjustTime(events: [HLLEvent]) -> [HLLEvent] {
    
    var returnArray = [HLLEvent]()
    
    for event in events {
        
        var newEvent = event
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: event.startDate)
                if let weekday = components.weekday {
                
                let formattedStart = event.startDate.formattedTimeTwelve()
                let formattedEnd = event.endDate.formattedTimeTwelve()
                
                if Weekday.standardMagdaleneTimetableDay.contains(weekday) {
                    
                    if formattedStart == "10:10am", formattedEnd == "11:25am" {
                        newEvent.startDate = event.startDate - 300 // Adjust period 2 start to 5 minutes earlier.
                    }
                    
                    if formattedStart == "1:20pm", formattedEnd == "2:35pm" {
                        newEvent.startDate = event.startDate - 300 // Adjust period 4 start to 5 minutes earlier.
                    }

                } else if weekday == Weekday.Tuesday {
                    
                    if formattedStart == "10:35am", formattedEnd == "11:25am" {
                        newEvent.startDate = event.startDate - 300 // Adjust period 2 start to 5 minutes earlier.
                    }
                    
                }
                
                
            }
        }
        
        returnArray.append(newEvent)
        
    }
    
    return returnArray
        
    }
    
}
