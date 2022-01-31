//
//  HLLTimelineEntry.swift
//  How Long Left
//
//  Created by Ryan on 27/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

struct HLLTimelineEntry {
    
    var showAt: Date
    var event: HLLEvent?
    var nextEvents: [HLLEvent]
    var switchToNext = true
    
    var showInfoIfAvaliable = false
    
    var nextEvent: HLLEvent? {
        
        get {
            
            return nextEvents.first
            
            
        }
        
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
    
    func getCodableEntry() -> CodableEntry {
        
        return CodableEntry(showAt: self.showAt, eventID: self.event?.infoIdentifier)
        
    }
    
    struct CodableEntry: Codable {
        
        var showAt: Date
        var eventID: String?
        
    }
    
}
