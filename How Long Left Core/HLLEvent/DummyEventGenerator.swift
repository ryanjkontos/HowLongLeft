//
//  DummyEventGenerator.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 4/12/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation

class DummyEventGenerator {
    
    var events = [HLLEvent]()
    
    let amount = 5
    
    
    
    init() {
        
        var start = Date()
        
        var array = [HLLEvent]()
        var date = start
        
        array.append(HLLEvent(title: "Ending Soon", start: start, end: start.addingTimeInterval(13), location: nil))
        
        for i in 1...amount {
            
            
            date.addTimeInterval(30*300)
            var event = HLLEvent(title: "Current \(i)", start: start, end: date, location: nil)
            event.associatedCalendar = HLLEventSource.shared.getCalendars().randomElement()
            array.append(event)
            
            start.addTimeInterval(60*120)
            
        }
        
        var upcomingStart = Date() + 20
        
       /* for i in 1...amount {
            
            
           
            var event = HLLEvent(title: "Upcoming \(i)", start: upcomingStart, end: upcomingStart.addingTimeInterval(60*30), location: nil)
            event.associatedCalendar = HLLEventSource.shared.getCalendars().randomElement()
            array.append(event)
            upcomingStart.addTimeInterval(60*60)
            
        } */
        
        events = array
        
    }
    
    
}
