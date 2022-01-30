//
//  HLLTimelineGenerator.swift
//  How Long Left
//
//  Created by Ryan on 27/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

class HLLTimelineGenerator {
    
    let percentDateFetcher = PercentDateFetcher()
    
    var type: TimelineType
    
    init(type: TimelineType) {
        self.type = type
    }
    
    func generateTimelineItems(fast: Bool = false, percentages: Bool = false, forState: TimelineState) -> HLLTimeline {
        
        
        
        let sessionID = Date().formattedTime(seconds: true)
        
        var events = Array(HLLEventSource.shared.eventPool.filter({$0.isHidden == false}))
       
        events.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
        var entryDates = Set<Date>()
        
        
        entryDates.insert(Date())
        
        let midnightTomorrow = Date().startOfDay().addDays(3)
        
        print("Midnight Tomorrow: \(midnightTomorrow.formattedDate()), \(midnightTomorrow.formattedTime())")
        
        if fast == false {
        
            
        for event in events {
          
            if percentages {
                entryDates.formUnion(percentDateFetcher.fetchPercentDates(for: event, every: 6))
            }
                
            entryDates.insert(event.startDate)
            entryDates.insert(event.endDate)
            
            if event.completionStatus == .done || event.isHidden {
                
                if let index = events.firstIndex(of: event) {
                    
                    events.remove(at: index)
                    
                }
                
            }
            
        }
            
        }
        
        
        var dictOfAdded = [Date:HLLEvent]()
        
        var midnightedDates = [Date]()
        
        var newDates = [Date]()
        
        entryDates = entryDates.filter({ $0 < midnightTomorrow })
        
        for date in entryDates {
            
            let midnight = date.startOfDay()
            
            if midnightedDates.contains(midnight) == false {
                midnightedDates.append(midnight)
                
                newDates.append(midnight)
                
                let modifiedDate = Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
                
                newDates.append(modifiedDate)
                
            }
            
        }
        
        for date in newDates {
        
            entryDates.insert(date)
            
        }
        
        
        entryDates = Set(entryDates.sorted(by: { $0.compare($1) == .orderedAscending }))
        
        var returnItems = [HLLTimelineEntry]()
        
        for date in entryDates {
            
            if date.timeIntervalSinceNow < -1 {
                continue
            }
            
            let next = getNextEventsToStart(after: date, from: events)
            
            if let event = getNextEventToStartOrEnd(at: date, from: events) {
                
                
                let entry = HLLTimelineEntry(date: date, event: event, nextEvents: next)
                returnItems.append(entry)
                dictOfAdded[date] = event
                
            } else {
                
                let entry = HLLTimelineEntry(date: date, event: nil, nextEvents: next)
                returnItems.append(entry)
                
            }

            
        }

       // var empty = events.isEmpty
        
        if returnItems.isEmpty == true {
            
          //  empty = true
            
            let nextEv = getNextEventsToStart(after: Date(), from: events)
            
            //print("CompSim6: \(Date().formattedDate()) \(Date().formattedTime()): No event is on, Next: \(nextEv?.title ?? "None")")
            returnItems.append(HLLTimelineEntry(date: Date(), event: nil, nextEvents: nextEv))
            HLLDefaults.defaults.set("returnItems empty", forKey: "ComplicationDebug")
        }
        
        returnItems.sort(by: { $0.showAt.compare($1.showAt) == .orderedAscending })

            
        var state = TimelineState.notPurchased
        if HLLDefaults.watch.complicationEnabled {
            state = .normal
        }
        
        var timelineID = returnItems.reduce("", { result, entry in
            
            let string = "\(entry.showAt): \(entry.event?.infoIdentifier ?? "No Event")"
            return "\(result), \(string)"
            
        })
        
        
        timelineID += Version.currentVersion
        
        timelineID = timelineID.MD5ifPossible
        
        let timeline = HLLTimeline(state: state, entries: returnItems, includedEvents: events, infoHash: timelineID)
        
 
        print("Returning timeline with \(timeline.entries.count) entries")
        
        for entry in timeline.entries {
            
            var statusString = ""
            if let status = entry.event?.completionStatus(at: entry.showAt) {
                statusString = status.debugDescription
            }
            
            print("Timeline Entry \(entry.showAt.formattedDate()) \(entry.showAt.formattedTime()), \(entry.event?.title ?? "No Event"), \(statusString)")
            
        }
        
        return timeline
    }
    
    func getSoonestEndingEvent(at date: Date, from events: [HLLEvent]) -> HLLEvent? {
        
        var currentEvents = [HLLEvent]()
        
        for event in events {
            
            if event.completionStatus(at: date) == .current {
                
                currentEvents.append(event)
                
            }
        }
        
        currentEvents.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        
       
        
        for event in currentEvents {
            print("On at time: \(event.title)")
        }
        
        
        return currentEvents.first
        
    }
    
  
    
    func getNextEventToStartOrEnd(at date: Date, from events: [HLLEvent]) -> HLLEvent? {
        
        var doSelected = false
        
            
            if HLLDefaults.widget.showSelected {
                doSelected = true
            }
            
        
        
        if doSelected {
        
        if let selected = SelectedEventManager.shared.selectedEvent {
            if selected.completionStatus(at: date) != .done {
                return selected
            }
        }
            
        }
        
        var currentEvents = [HLLEvent]()
        
        for event in events {
            
            if event.completionStatus(at: date) != .done {
                
                currentEvents.append(event)
                
            }
        }
        
        currentEvents.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
        
        
        return currentEvents.first
        
    }

    func getNextEventsToStart(after date: Date, from events: [HLLEvent]) -> [HLLEvent] {
        
        var upcomingEvents = [HLLEvent]()
        
        for event in events {
            
            if event.startDate.timeIntervalSince(date) > 0, event.startDate != date {
                
                upcomingEvents.append(event)
                
            }
        }
        
        return upcomingEvents
        
        
    }
    

    
    func shouldUpdate() -> TimelineValidity {
        
        let timeline = generateTimelineItems(forState: .normal)
        let newTimeline = timeline.getCodableTimeline()
        
        guard let currentTimeline = HLLDefaults.complication.latestTimeline else {
            
            print("Needs reloading because no stored timeline.")
            return .needsReloading
            
        }
        
        
        if newTimeline.events.isSubset(of: currentTimeline.events) == false {
            print("Needs reloading because the old timeline did not contain events that the new one does")
            return .needsReloading
        }
    
        let date = newTimeline.creationDate
    
        
        let newDict = newTimeline.getEntryDictionary(after: date)
        let currentDict = currentTimeline.getEntryDictionary(after: date)
        
        
        if newDict != currentDict {
            print("Timeline dicts did not match, should reload.")
            return .needsReloading
        }
        
        print("Timeline dicts matched, no need to reload.")
        
        return .noUpdateNeeded
        
        
        
    }
    
    enum TimelineValidity {
        
        case noUpdateNeeded
        case needsReloading
        case needsExtending
        
    }
    
}

