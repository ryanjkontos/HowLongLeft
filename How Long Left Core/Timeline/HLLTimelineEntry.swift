//
//  HLLTimelineEntry.swift
//  How Long Left
//
//  Created by Ryan on 27/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

struct HLLTimelineEntry: Codable {
    
    var showAt: Date
    var event: HLLEvent?
    var nextEvents: [HLLEvent]
    var switchToNext = true
    
    var showInfoIfAvaliable = false
    
    var eventID: String? {
        return event?.infoIdentifier
    }
    
    var nextEvent: HLLEvent? {
        
        get {
            
            return nextEvents.first
            
            
        }
        
    }
    
    func getAdjustedShowAt() -> Date {
        
        if showAt.hasOccured {
            return Date()
        }
        
        return showAt
        
    }
    
    init(date: Date, event currentEvent: HLLEvent?, nextEvents: [HLLEvent] = [HLLEvent]()) {
        showAt = date
        event = currentEvent
        self.nextEvents = nextEvents
        
    }
    
    func getComp() -> String {
        
        var comp = "none"
        
        if let status = event?.completionStatus {
            
            switch status {
            
            case .upcoming:
                comp = "upcoming"
            case .current:
                comp = "current"
            case .done:
                comp = "done"
            }
            
        }
        
        return comp
        
    }
    
    var idString: String {
        
        get {
            
            return "\(showAt.formattedDate()), \(showAt.formattedTime()): \(event?.persistentIdentifier ?? "No current"), \(getComp()) \(nextEvents.count)"
            
        }
        
        
    }
    
    
}
