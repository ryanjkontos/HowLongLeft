//
//  HLLTimelineGenerator.swift
//  How Long Left
//
//  Created by Ryan on 27/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLTimelineGenerator {
    
    let percentDateFetcher = PercentDateFetcher()
    
    var type: TimelineType
    
    init(type: TimelineType) {
        self.type = type
    }
    
    func generateTimelineItems(fast: Bool = false, forState: TimelineState) -> HLLTimeline {
        
       
        
        var events = Array(HLLEventSource.shared.eventPool.filter({$0.isHidden == false}))
       
        events.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
        var entryDates = Set<Date>()
        
        
        entryDates.insert(Date())
        
        if fast == false {
        
        for event in events.prefix(6) {
          
            
            entryDates.formUnion(percentDateFetcher.fetchPercentDates(for: event, every: 6))
            
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
            
          /*  if let current = getSoonestEndingEvent(at: date, from: events) {
                
                let next = getNextEventsToStart(after: current.startDate, from: events)
                
                //print("CompSim1: \(date.formattedDate()) \(date.formattedTime()): \(current.title), Next: \(String(describing: next?.title))")
                
                let entry = HLLTimelineEntry(date: date, event: current, nextEvents: next)
                
                if getSoonestEndingEvent(at: current.startDate.addingTimeInterval(600), from: events) != current {
                    
                    entry.switchToNext = false
                    
                }
                
                returnItems.append(entry)
                dictOfAdded[date] = current
                
                
                
                
            } else {
                
                let nextEv = getNextEventsToStart(after: date, from: events)
                //print("CompSim2: \(date.formattedDate()) \(date.formattedTime()): No events are on")
                returnItems.append(HLLTimelineEntry(date: date, event: nil, nextEvents: nextEv))
                
            } */
            
        }
       
      /*  if HLLEventSource.shared.getCurrentEvents().isEmpty == true {
            
            let nextEv = getNextEventsToStart(after: Date(), from: events)
            
            //print("CompSim5: \(Date().formattedDate()) \(Date().formattedTime()): No event is on, Next: \(nextEv?.title ?? "None")")
            returnItems.append(HLLTimelineEntry(date: Date(), event: nil, nextEvents: nextEv))
            
        } */
        
        if returnItems.isEmpty == true {
            
            let nextEv = getNextEventsToStart(after: Date(), from: events)
            
            //print("CompSim6: \(Date().formattedDate()) \(Date().formattedTime()): No event is on, Next: \(nextEv?.title ?? "None")")
            returnItems.append(HLLTimelineEntry(date: Date(), event: nil, nextEvents: nextEv))
            HLLDefaults.defaults.set("returnItems empty", forKey: "ComplicationDebug")
        }
        
        returnItems.sort(by: { $0.showAt.compare($1.showAt) == .orderedAscending })

            
        
        let timeline = HLLTimeline(state: forState, entries: returnItems, includedEvents: events)
        
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
        
        if type == .widget {
            
            if HLLDefaults.widget.showSelected {
                doSelected = true
            }
            
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
    
}

struct HLLTimeline {
    
    internal init(state: TimelineState, entries: [HLLTimelineEntry], includedEvents: [HLLEvent]) {
        self.entries = entries
        self.state = state
        self.includedEvents = includedEvents
    }
    
    var state: TimelineState
    
    var includedEvents: [HLLEvent]
    var entries: [HLLTimelineEntry]
    
}

