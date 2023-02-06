//
//  HLLEventSource.swift
//  How Long Left
//
//  Created by Ryan Kontos on 15/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//  Retreives data from the calendar.
//
import Foundation
import EventKit
import os
import Combine


/**
 * Methods for retriving HLLEvents/
 */

let CXLogger = Logger(subsystem: "HLL", category: "ComplicationLogger")

class HLLEventSource {
    
    static var shared: HLLEventSource! = HLLEventSource()
    
    var events = [HLLEvent]()
    var eventsKeyDates = [Date]()
    var hiddenEvents = [HLLEvent]()
    var eventsObservers = [EventSourceUpdateObserver]()
    var addBreaks = true
  
    var neverUpdatedevents = true
    var saCals = [String]()
    private let remover = DoubleEventRemover()
    static let queue = CollatingQueue(label: "HLLEventUpdateQueue")
    var eventsUpdateTimer: Timer!
    var eventsUpdateRequestedDuringCooldown = false
    var updating: Bool { return eventsUpdatingCounter != 0 }
    lazy var dummyGen = DummyEventGenerator()
    var eventsUpdatingCounter = 0
    
    let shiftLoader = RemoteHWShiftLoader()
    
    var calendarFetcher: (() -> [EKCalendar]) = {
        return CalendarDefaultsModifier.shared.getEnabledCalendars()
    }
    
    private var closures: [(() -> Void)] = []
       
       func addClosure(closure: @escaping () -> Void) {
           
           if neverUpdatedevents {
               CXLogger.log("Adding never updated closure")
               closures.append(closure)
           } else {
               DispatchQueue.main.async {
                   CXLogger.log("Adding immediate closure")
                   closure()
               }
              
           }
           
          
           
       }
       
    
    
    init() {
       
        
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }

        eventsUpdateTimer = Timer(timeInterval: 600, target: self, selector: #selector(updateEventsAsync), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(
         self,
         selector: #selector(self.eventStoreChanged),
         name: .EKEventStoreChanged,
         object: nil)
         
    }
    
    @objc func updateEventsAsync(bypassCollation: Bool = false) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.updateEvents(bypassCollation: bypassCollation)
        }
        
    }
    
    @objc func eventStoreChanged() {
        // print("Event Store Changed")
        self.updateEventsAsync()
    }
    
 
    func updateEvents(full: Bool = true, bypassCollation: Bool = false) {
        
   
        
        HLLEventSource.queue.sync(bypassCollation: bypassCollation) { [self] in
            
            
            // print("Updating event store!")
            
            CXLogger.log("Updating Events")
            
            if CalendarReader.shared.calendarAccess != .Granted {
                CXLogger.log("No calendar access")
                return }
            
            
            
            var days: Int
            
            if full {
                days = 365
            }
            
            #if os(watchOS)
                days = 7
            #else
                days = 14
            #endif
            
           
                        
            
            let start = Date()-500
            let end = Calendar.current.date(byAdding: .day, value: days, to: start)!
            
            var add = CalendarReader.shared.getEventsFromCalendar(start: start, end: end, usingCalendars: calendarFetcher())
            
            if HLLDefaults.general.showAllDay == false { add = add.filter { !$0.isAllDay } }
            
            add.append(contentsOf: dummyGen.events)
            add = remover.removeDoublesIn(events: add)
            add = NicknameManager.shared.addNicknames(for: add)
            addPinnedTo(with: &add)
            FollowingOccurenceStore.shared.updateNextOccurenceDictionary(events: add)
            HLLStoredEventManager.shared.updateStoredEvents(from: add)
            shiftLoader.addShiftEvents(to: &add)
            
            add.sortEvents(mode: .startDate)
            
            let previousevents = self.events
            
            self.events = Array(Set(add))
            
            
            updateHiddenEvents()
            
            HWEventFinder.shared.checkForHWEvent(from: self.events)
            
            let prevNeverUpdated = neverUpdatedevents
            
            self.neverUpdatedevents = false
     
            
            if previousevents != self.events {
                
                notifyEventSourceUpdateObservers()
                
            } else {
                
                if prevNeverUpdated {
                    notifyEventSourceUpdateObservers()
                }
                
            }
            
           // // print("Updated event pool with \(self.events.count) events")
            
            CXLogger.log("Updated event pool with \(self.events.count) events")
            
            if full == false {
                DispatchQueue.global(qos: .background).async {
                    self.updateEvents(full: true)
                }
                
            }
            
        }

    }
    
    func addPinnedTo(with events: inout [HLLEvent]) {
        
        var existingPinnedIDS = [String]()
        
        for (i, event) in events.enumerated() {

                
            if HLLDefaults.general.pinnedEventIdentifiers.contains(event.persistentIdentifier) {
                
                events[i].isUserHideable = false
                existingPinnedIDS.append(event.persistentIdentifier)
            }
                
        }
        
        let pinned = self.getPinnedEvents()
        
        for pinnedEvent in pinned {
            

            if existingPinnedIDS.contains(pinnedEvent.persistentIdentifier) == false {
                    events.append(pinnedEvent)
            
                
            }
            
            
        }
        
    }
    
    func updateEventsPinned() {

        var events = self.events
        self.addPinnedTo(with: &events)
        self.events = events
        updateHiddenEvents()
        notifyEventSourceUpdateObservers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // print("Async trigger 2")
            self.updateEventsAsync()
        }
    
    }
    
    func updateHiddenEvents() {
        
        #if os(macOS)
        
        if ProStatusManager.shared.isPro == false {
            return
        }
        
        #endif
         
        let ids = HLLStoredEventManager.shared.hiddenEvents.compactMap({$0.identifier})
        
        self.events = events.filter({ event in
                   
            if let ekID = event.eventIdentifier {
                if ids.contains(ekID) { return false }
            } else {
                if ids.contains(event.persistentIdentifier) { return false }
            }
            
            return true
                   
        })
        
    }

    
    func getEventsFromStore(start: Date, end: Date) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        if events.isEmpty {
            return returnArray
        }
        
        let poolEvents = events
        
        for event in poolEvents {
            
            if event.startDate.timeIntervalSince(end) < 0, event.endDate.timeIntervalSince(start) > 0 {
                returnArray.append(event)
            }
            
        }
        
        returnArray.sortEvents(mode: .startDate)
        
        return returnArray
        
    }
    
 
    
    func getPinnedEvents() -> [HLLEvent] {
        return events.filter({ $0.isPinned })
    }
    

    func findEventWithIdentifier(id: String) -> HLLEvent? {
    
        if let event = events.first(where: {
            return $0.persistentIdentifier == id}) {
            return event
        } else {
            return events.first(where: {$0.persistentIdentifier == id})
        }

    }
    
    func findEventWithAppIdentifier(id: String) -> HLLEvent? {
        return events.first(where: {$0.persistentIdentifier == id})
    }
    
    func findEventsWithAppIdentifier(ids: [String]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        for id in ids {
            returnArray.append(contentsOf: events.filter({$0.persistentIdentifier == id }))
        }
        return returnArray
        
    }
    
    func fetchEventsOnDay(day: Date) -> [HLLEvent] {
        let start = day.startOfDay()
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        return CalendarReader.shared.getEventsFromCalendar(start: start, end: end!, usingCalendars: calendarFetcher())
    }
    
    func fetchEventsOnDays(days: [Date]) -> [HLLEvent] {
        var returnArray = [HLLEvent]()
        for day in days {
            returnArray.append(contentsOf: fetchEventsOnDay(day: day))
        }
        returnArray.sortEvents(mode: .startDate)
        return returnArray
    }

    
    func getPrimaryEvent(excludeSelected: Bool = false) -> HLLEvent? {
          
        
        if excludeSelected == false {
        
        if let selected = SelectedEventManager.shared.selectedEvent, selected.completionStatus != .done {
            return selected
        } else {
            
            if SelectedEventManager.shared.selectedEvent != nil {
              SelectedEventManager.shared.selectedEvent = nil
            }
            
        }
            
        }
        
        if HLLDefaults.statusItem.eventMode == .onlySelected {
            return nil
        }
        
        if HLLDefaults.statusItem.eventMode == .upcomingOnly {
            return getUpcomingEventsFromNextDayWithEvents().1.first
        }
        
        let current = getCurrentEvents(includeHidden: false).first
        
        if HLLDefaults.statusItem.eventMode == .currentOnly {
            return current
        }
          
        let upcoming = getUpcomingEventsFromNextDayWithEvents().1.first
        
        let merged = [current, upcoming].compactMap({return $0})
        
        if HLLDefaults.statusItem.eventMode == .bothPreferCurrent {
            return merged.first
        }
        
        if HLLDefaults.statusItem.eventMode == .bothPreferSoonest {
            return merged.sorted(by: { $0.countdownDate.compare($1.countdownDate) == .orderedAscending }).first
        }
        
        return nil
        
    }
    
    func getCurrentEvent() -> HLLEvent? {
        
        return getCurrentEvents().first
        
    }
    
    
    let getCurrentEventsQueue = DispatchQueue(label: "getCurrentEvents")
    
    func getCurrentEvents(includeHidden: Bool = false, includeSelected: Bool = true, date: Date = Date()) -> [HLLEvent] {
        
        var currentEvents = [HLLEvent]()
        
        for event in self.events {
            
            if event.completionStatus(at: date) == .current && (!HLLStoredEventManager.shared.isHidden(event: event) || includeHidden)  {
                
  
                if (includeSelected == false && event.isSelected) {
                    continue
                }
                
                currentEvents.append(event)
 
                
            }
        }
        
        
        currentEvents.sortEvents(mode: .countdownDate, at: date)
        
        return currentEvents
    }
    
    func getTopShelfEvents() -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        let current = getCurrentEvents(includeHidden: true)
        returnArray.append(contentsOf: current)
        returnArray = Array(Set(returnArray)).sorted(by: { $0.countdownDate.compare($1.countdownDate) == .orderedAscending })
        
        if current.isEmpty {
            if let next = getNextUpcomingEvent() {
                returnArray.insert(next, at: 0)
            }
            
        } else {
            
            if let next = getNextUpcomingEvent() {
                
                let nextInterval = next.countdownDate.timeIntervalSince(CurrentDateFetcher.currentDate)
                var add = true
                
                for event in current {
                    
                    let interval = event.countdownDate.timeIntervalSince(CurrentDateFetcher.currentDate)
                    
                    if interval < nextInterval {
                        add = false
                    }
                    
                    if event.countdownDate == next.countdownDate {
                        add = false
                    }
                    
                }
            
                if add {
                
                returnArray.insert(next, at: 0)
                    
                }
            }
            
            
            
        }
        
        return returnArray
        
    }
    
    func getPinnedEventsFromevents() -> [HLLEvent] {
        
        return events.filter({$0.isPinned})
        
    }
    
    func getRecentlyEndedEvents() -> [HLLEvent] {
        
        let events = events.filter { $0.completionStatus == .done && $0.endDate.timeIntervalSince(CurrentDateFetcher.currentDate) > -300 }
        return events.sorted(by: { $0.endDate.compare($1.endDate) == .orderedDescending })
        
    }
    
    func getNextUpcomingEvent() -> HLLEvent? {
        
        return getUpcomingEventsFromNextDayWithEvents().1.first
        
    }
    
    func getUpcomingEvents(limit: Int) -> [HLLEvent] {
        
        var allUpcoming = events.filter({$0.completionStatus == .upcoming})
        allUpcoming.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        return Array(allUpcoming.prefix(limit))
        
    }
    
    func getUpcomingEventsToday() -> [HLLEvent] {
        
        let start = Date().startOfDay()
        let end = start.endOfDay()
        
        let eventsToday = getEventsFromStore(start: start, end: end)
        
        var upcomingEvents = [HLLEvent]()
        
        for event in eventsToday {
            
            if event.startDate.timeIntervalSince(CurrentDateFetcher.currentDate) > 0 {
                
                upcomingEvents.append(event)
                
            }
        }
        
        return upcomingEvents.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
    }
    
    func getTimeline(includeRecentlyEnded: Bool = false, includeUpcoming: Bool = true, chronological: Bool = true) -> [HLLEvent] {
        
        var events = [HLLEvent]()
        
        if includeRecentlyEnded {
        events.append(contentsOf: getRecentlyEndedEvents())
        }
        
        events.append(contentsOf: getCurrentEvents(includeHidden: true))
        
        if includeUpcoming {
            events.append(contentsOf: getUpcomingEventsFromNextDayWithEvents(includeStarted: false).1)
        }
         
        if chronological {
        events.sort(by: { $0.countdownDate.compare($1.countdownDate) == .orderedAscending })
        }
        
        //// print("Get timeline returning \(events.count) events")
        
        return events
        
    }

    func getUpcomingEventsFromNextDayWithEvents(includeStarted: Bool = false, date: Date = Date()) -> (Date, [HLLEvent]) {
        
        var upEvents = [HLLEvent]()
        var returnEvents = [HLLEvent]()
        
        var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: date)
        comp.timeZone = TimeZone.current
        var loopStart = NSCalendar.current.date(from: comp)!
        var loopEnd = Calendar.current.date(byAdding: .day, value: 1, to: loopStart)
        
        outer: for _ in 1...7 {
            
            upEvents = getEventsFromStore(start: loopStart, end: loopEnd!)
            var notStarted = [HLLEvent]()
            
            for event in upEvents {
                
                if event.startDate.timeIntervalSince(date) > 0 || includeStarted == true, event.startDate.startOfDay() == loopStart.startOfDay() {
                    
                    notStarted.append(event)
                    
                }
            }
            
            if notStarted.isEmpty == false {
                returnEvents = notStarted
                break outer
            }
            
            var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: loopStart)
            comp.timeZone = TimeZone.current
            loopStart = NSCalendar.current.date(from: comp)!
            loopStart = Calendar.current.date(byAdding: .day, value: 1, to: loopStart)!
            loopEnd = Calendar.current.date(byAdding: .day, value: 1, to: loopEnd!)
            
        }
      
        
        return (loopStart.startOfDay(), returnEvents.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending }))
        
    }
    
    func getArraysOfUpcomingEventsForDates(startDate: Date, endDate: Date, returnEmptyItems: Bool) -> [DateOfEvents] {
        
        precondition(startDate < endDate, "Start date was after end date.")
        
        var returnArray = [DateOfEvents]()
        var foundEvents = false
        
        var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: startDate)
        comp.timeZone = TimeZone.current
        
        var loopStart = startDate.startOfDay()
        
        var loopEnd = Calendar.current.date(byAdding: .day, value: 1, to: loopStart)!.startOfDay()
        
        while loopStart < endDate {
            
            var events = getEventsFromStore(start: loopStart, end: loopEnd).sorted(by: {
                $0.startDate.compare($1.startDate) == .orderedAscending })
            
           events.removeAll { event in
                
                if event.completionStatus != .upcoming {
                    
                    if event.startDate == loopStart.startOfDay() {
                        return false
                    }
                    
                    return true
                    
                }
                
                return false
                
                
            }
            events.removeAll { $0.completionStatus == .current }
            events.removeAll { $0.startDate.startOfDay() != loopStart.startOfDay() }
            
            
            if events.isEmpty {
                
                if returnEmptyItems {
                    
                    var item = DateOfEvents(date: loopStart, events: events)
                    item.headerString = loopStart.userFriendlyRelativeString()
                    
                  returnArray.append(item)
                    
                }
                
                
            } else {
                
                var item = DateOfEvents(date: loopStart, events: events)
                item.headerString = loopStart.userFriendlyRelativeString()
                
                returnArray.append(item)
                foundEvents = true
            }
            
            var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: loopStart)
            comp.timeZone = TimeZone.current
            loopStart = Calendar.current.date(byAdding: .day, value: 1, to: loopStart)!
            loopEnd = Calendar.current.date(byAdding: .day, value: 1, to: loopEnd)!
            
        }
        
        
        returnArray.sort(by: {
            
            $0.date.compare($1.date) == .orderedAscending
            
        })
        
        if foundEvents == false {
            returnArray.removeAll()
        }
        
        return returnArray
        
    }
    
    func getAllEventsGroupedByDate(_ excludeIDs: [String]? = nil, maxCount: Int? = nil, upcomingOnly: Bool = false, at date: Date = Date(), excludePinned: Bool = false, groupMode: HLLEvent.SortMode, focusedCalendarID: String? = nil) -> [DateOfEvents] {
        
        var events = events.sortedEvents(mode: groupMode, at: date)
        
        if let focused = focusedCalendarID {
            events = events.filter({ $0.calendarID == focused })
        }
        
        if upcomingOnly {
            events = events.filter({$0.completionStatus(at: date) == .upcoming})
        }
        
        if excludePinned {
            events = events.filter({!$0.isPinned})
        }
        
        
        if let excludeIDs = excludeIDs {
            events.removeAll(where: { event in
                excludeIDs.contains(event.persistentIdentifier)
            })
        }
        
        if let max = maxCount {
            events = Array(events.prefix(max))
        }
        
        
        
        let returnArray = events.groupedByDate(at: date,sortMode: groupMode)
        
            
   
       
        return returnArray.sorted(by: { $0.date.compare($1.date) == .orderedAscending })


        
    }
    
    func getArraysOfUpcomingEventsForNextSevenDays(returnEmptyItems: Bool, allowToday: Bool) -> [DateOfEvents] {
        
        var start = Date().startOfDay()
        if !allowToday {
            start = start.addDays(1)
        }
        let end = start.addDays(7)
        
       return getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: returnEmptyItems)
        
    }

    
    func addeventsObserver(_ observer: EventSourceUpdateObserver, immediatelyNotify: Bool = false) {
        
        self.eventsObservers.append(observer)
        
        if immediatelyNotify, !neverUpdatedevents {
            DispatchQueue.main.async {
                
                observer.eventsUpdated()
            }
        }
        
        
       // // print("There are now \(self.eventsObservers.count) evnent pool update observers.")
        
       
        
    }
    
    func notifyEventSourceUpdateObservers() {
        
        self.eventsObservers.forEach { observer in
                
            DispatchQueue.global(qos: .userInteractive).async {
                
                observer.eventsUpdated()
            }
                
        }
        
    }
    
}

protocol CalendarAccessStateDelegate {
    func calendarAccessDenied()
}


protocol EventSourceUpdateObserver {
    
    func eventsUpdated()
    
}

extension Date {
    
    func addDays(_ days: Int) -> Date {
        
        Calendar.current.date(byAdding: .day, value: days, to: self)!
        
    }
    
}
