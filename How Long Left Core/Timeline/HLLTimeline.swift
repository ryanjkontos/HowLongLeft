//
//  HLLTimeline.swift
//  How Long Left
//
//  Created by Ryan Kontos on 28/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct HLLTimeline: Codable {
    
    var state: TimelineState
    var includedEvents: [HLLEvent]
    var entries: [HLLTimelineEntry]
    var creationDate: Date
    
    var appVersion: String
    
    var events: Set<String> {
        return Set(entries.map({($0.eventID ?? "No Event").MD5ifPossible}))
    }
    
    internal init(state: TimelineState, entries: [HLLTimelineEntry], includedEvents: [HLLEvent]) {
        self.entries = entries
        self.state = state
        self.includedEvents = includedEvents
        self.creationDate = Date()
        self.appVersion = Version.currentVersion
    }
    
    func entriesAfterDate(_ date: Date?) -> [HLLTimelineEntry] {
        self.entries
    }
    
    func eventBeingShownAt(date: Date) -> String? {
        
        let sortedEntries = entries.sorted(by: { $0.showAt.compare($1.showAt) == .orderedAscending })
        
        for entry in sortedEntries.reversed() {
            if entry.showAt <= date {
                return entry.eventID
            }
        }
        
        return nil
    }
    
    func getEntryDictionary(after date: Date) -> [String:String] {
        
        var returnArray = [String:String]()
        
        for entry in entries {
            returnArray[String(Int(entry.showAt.timeIntervalSinceReferenceDate) )] = (entry.eventID ?? "No Event")
        }
        
        return returnArray
        
    }
    
    
    
}
