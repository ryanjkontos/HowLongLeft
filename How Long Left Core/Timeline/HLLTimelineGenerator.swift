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
        
        if fast == false {
        
        for event in events.prefix(10) {
          
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

        
        if returnItems.isEmpty == true {
            
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
        
        let timeline = HLLTimeline(state: state, entries: returnItems, includedEvents: events)
        
 
        for item in timeline.entries {
            
            if let event = item.event {
                print("GeneratedTimeline \(sessionID): \(item.showAt.formattedTime(seconds: true)): \(event.title): \(event.startDate.formattedTime(seconds: true)) - \(event.endDate.formattedTime(seconds: true))")
            } else {
                print("GeneratedTimeline \(sessionID): \(item.showAt.formattedTime(seconds: true)): No Event")
            }
            
            
            
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
        let codableInput = timeline.getCodableTimeline()
        
        guard let storedTimeline = HLLDefaults.complication.latestTimeline else { return .needsReloading }
        
        print("Comparing with stored timeline created \(Date().timeIntervalSince(storedTimeline.creationDate)) ago")
        
        if let lastEntry = codableInput.lastEntryDate {
            
            let time = lastEntry.timeIntervalSinceNow
            print("Time til last entry: \(time)")
            
            if time < (44990) {
                return .needsReloading
            }
            
        } else {
            return .needsReloading
        }
        
        if timeline.state != storedTimeline.state { return .needsReloading }
        
        let filteredEntries = storedTimeline.codableEntries.filter({ $0.showAt >= codableInput.creationDate })
        
        for entry in filteredEntries {
            
            let eventFromInput = codableInput.eventBeingShownAt(date: entry.showAt)
            if eventFromInput != entry.eventID {
                return .needsReloading
            }
        }
        
        return .noUpdateNeeded
        
    }
    
    enum TimelineValidity {
        
        case noUpdateNeeded
        case needsReloading
        case needsExtending
        
    }
    
}

