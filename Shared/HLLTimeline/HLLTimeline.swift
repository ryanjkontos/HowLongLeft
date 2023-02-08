//
//  HLLTimeline.swift
//  How Long Left
//
//  Created by Ryan Kontos on 28/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import CryptoKit

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
        
        guard let date = date else { return entries}
        
        return self.entries
    }
    
    func eventBeingShownAt(date: Date) -> String? {
        
        let sortedEntries = entries.sorted(by: { $0.date.compare($1.date) == .orderedAscending })
        
        for entry in sortedEntries.reversed() {
            if entry.date <= date {
                return entry.eventID
            }
        }
        
        return nil
    }
    
    func getEntryDictionary() -> [String:String] {
        
        var returnArray = [String:String]()
        
        for entry in entries {
            returnArray[String(Int(entry.date.timeIntervalSinceReferenceDate) )] = (entry.eventID ?? "No Event")
        }
        
        return returnArray
        
    }
    
    func getEntriesHash() -> String {
        
        let dict = getEntryDictionary()
        
        return dict.description.MD5ifPossible
    }
    
    func getArchive() -> HLLTimeline.Archive {
        return HLLTimeline.Archive(state: self.state, appVersion: self.appVersion, creationDate: self.creationDate, entryHash: getEntriesHash(), entryCount: entries.count)
    }
    
    struct Archive: Codable, Equatable, Hashable {
        
        var state: TimelineState
        var appVersion: String
        var creationDate: Date
        var entryHash: String
        var entryCount: Int
        
    }
    
}
