//
//  HLLTimelineEntry.swift
//  How Long Left
//
//  Created by Ryan on 27/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import WidgetKit

struct HLLTimelineEntry: Codable, CustomDebugStringConvertible, Equatable, TimelineEntry {
    
    var date: Date
    var event: HLLEvent?
    var nextEvents: [HLLEvent]
    var switchToNext = true

    
    var eventID: String? {
        
        guard let event = event else { return nil }
        
        return (event.infoIdentifier + String(event.modified.timeIntervalSinceReferenceDate)).MD5ifPossible
    }
    
    var nextEvent: HLLEvent? {
        
        get {
            
            return nextEvents.first
            
            
        }
        
    }
    
    func getAdjustedDate() -> Date {
        
        if date.hasOccured {
            return Date()
        }
        
        return date
        
    }
    
    init(date: Date, event currentEvent: HLLEvent?, nextEvents: [HLLEvent] = [HLLEvent]()) {
        self.date = date
        event = currentEvent
        self.nextEvents = nextEvents.filter({ current in
            
            if let event = currentEvent {
                if current.persistentIdentifier == event.persistentIdentifier {
                    return false
                }
            }
            
            return true
            
        })
        
        
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
            
            return "\(date.formattedDate()), \(date.formattedTime()): \(event?.persistentIdentifier ?? "No current"), \(getComp()) \(nextEvents.count)"
            
        }
        
        
    }
    
    var debugDescription: String {
        
        return "HLLTimelineEntry \(self.date.formattedDate()), \(self.date.formattedTime()): \(event?.title ?? "No Event")"
        
    }
    
    
}
