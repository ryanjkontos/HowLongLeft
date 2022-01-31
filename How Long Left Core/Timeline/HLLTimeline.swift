//
//  HLLTimeline.swift
//  How Long Left
//
//  Created by Ryan Kontos on 28/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct HLLTimeline {
    
    var state: TimelineState
    var includedEvents: [HLLEvent]
    var entries: [HLLTimelineEntry]
    var creationDate: Date

    
    internal init(state: TimelineState, entries: [HLLTimelineEntry], includedEvents: [HLLEvent]) {
        self.entries = entries
        self.state = state
        self.includedEvents = includedEvents
        self.creationDate = Date()
       
    }
    
    func entriesAfterDate(_ date: Date?) -> [HLLTimelineEntry] {
        
       
        self.entries
        
    }
    
    func getCodableTimeline() -> CodableTimeline {
        return CodableTimeline(creationDate: creationDate, lastEntryDate: self.entries.last?.showAt, state: state, codableEntries: entries.compactMap({ $0.getCodableEntry() }), appVersion: Version.currentVersion)
    }
    
    struct CodableTimeline: Codable {
        
        var creationDate: Date
        var lastEntryDate: Date?
        
        var state: TimelineState
        var codableEntries: [HLLTimelineEntry.CodableEntry]
        
        var appVersion: String
        
        var events: Set<String> {
            return Set(codableEntries.map({($0.eventID ?? "No Event").MD5ifPossible}))
        }
        
        func eventBeingShownAt(date: Date) -> String? {
            
            let sortedEntries = codableEntries.sorted(by: { $0.showAt.compare($1.showAt) == .orderedAscending })
            
            for entry in sortedEntries.reversed() {
                if entry.showAt <= date {
                    return entry.eventID
                }
            }
            
            return nil
        }
        
        func getEntryDictionary(after date: Date) -> [String:String] {
            
            var returnArray = [String:String]()
            
            for codableEntry in codableEntries {
                returnArray[String(Int(codableEntry.showAt.timeIntervalSinceReferenceDate) )] = (codableEntry.eventID ?? "No Event")
            }
            
            return returnArray
            
        }
        
    }
    
}
