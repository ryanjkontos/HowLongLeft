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
    
    let amount = 20
    
    
    
    init() {
        
        let start = Date()
        
        var array = [HLLEvent]()
        var date = start
        
        for i in 1...amount {
            
            
            date.addTimeInterval(30*60)
            var event = HLLEvent(title: "Event \(i)", start: start, end: date, location: nil)
            event.associatedCalendar = HLLEventSource.shared.getCalendars().randomElement()
            array.append(event)
            
        }
        
        events = array
        
    }
    
    
}
