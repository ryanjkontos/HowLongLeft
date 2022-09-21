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

/**
 * Methods for retriving HLLEvents/
 */

class HLLEventSource {
    
    static var shared = HLLEventSource()
    
    static var accessToCalendar = CalendarAccessState.Unknown
    var access = CalendarAccessState.Unknown
    var eventStore = EKEventStore()
    
    
    var eventPool = [HLLEvent]()
    var eventPoolKeyDates = [Date]()
    
    var hiddenEvents = [HLLEvent]()
    
    var eventPoolObservers = [EventPoolUpdateObserver]()

    var addBreaks = true
 
    var enabledCalendars = [EKCalendar]()
    var lastUpdatedWithCalendars = [String]()
    static var isRenaming = false
    var neverUpdatedEventPool = true
    
    var saCals = [String]()
    
    private let remover = DoubleEventRemover()
    
   

    var eventPoolUpdateTimer: Timer!
    var eventPoolUpdateRequestedDuringCooldown = false

    var updating: Bool {
        
        return eventPoolUpdatingCounter != 0
        
    }
    
    lazy var dummyGen = DummyEventGenerator()
   
    var eventPoolUpdatingCounter = 0
    
    init() {
        
      /* if let data = HLLDefaults.defaults.data(forKey: "EncodedEventPool"), let decoded = try? JSONDecoder().decode([HLLEvent].self, from: data) {
            print("Using decoded events")
            eventPool = decoded
        } */
        
        HLLDefaults.general.showAllDay = false
        
        print("Init es")
        
        eventPoolUpdateTimer = Timer(timeInterval: 600, target: self, selector: #selector(asyncUpdateEventPool), userInfo: nil, repeats: true)
        
        getCalendarAccess()
        
       NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.eventStoreChanged),
        name: .EKEventStoreChanged,
        object: nil)
        
    }
    
    func getCalendarAccess() {
        
            self.eventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                
                if let error = NSError {
                    
                    print("Cal access \(granted): \(error)")
                    
                }
                
                self.eventStore = EKEventStore()
                
                self.eventStore.reset()
               // self.eventStore.refreshSourcesIfNecessary()
                
                //print("CADB: Prevstate was \(prevState)")
                
                if granted == true {
                    //print("CADB: Granted")
                    HLLEventSource.accessToCalendar = .Granted
                    self.access = .Granted
                } else {
                    //print("CADB: Denied")
                    HLLEventSource.accessToCalendar = .Denied
                    self.access = .Denied
                }
    
                HLLEventSource.shared.updateEventPool()
                
            })
        
    }
    
    @objc func asyncUpdateEventPool() {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
    
          //  os_log("Updating the event pool, asynchronously.")
            
                self.updateEventPool()
      
            }
        
    }
    
    @objc func eventStoreChanged() {
        
        
        print("Event Store Changed")
        self.asyncUpdateEventPool()
        
    }
    
    static var updatingEventPool = false
    var goingToDoCatchupUpdate = false
    
    func doCatchupEventPoolUpdate() {
        
        goingToDoCatchupUpdate = false
        updateEventPool(catchup: true)
        
    }
    
    func updateEventPool(quick: Bool = false, catchup: Bool = false) {
        
        print("Event pool update requested")
        
        if access != .Granted {
            print("Returning bc no access")
            return
        }
        
        let eventPoolUpdateStart = CurrentDateFetcher.currentDate
        
        if neverUpdatedEventPool == false {
        
            if HLLEventSource.updatingEventPool {
            
            if goingToDoCatchupUpdate == false, catchup == false {
                
                goingToDoCatchupUpdate = true
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    
                    self.doCatchupEventPoolUpdate()
                    
                }
                
            }
            
            return
            
        }
            
        }
        
        eventPoolUpdatingCounter += 1
        
        HLLEventSource.updatingEventPool = true
        
        #if os(watchOS)
        
            let days = 7
        #else
            let days = 14
        #endif
        
    
        let start = CurrentDateFetcher.currentDate-500
        let end = Calendar.current.date(byAdding: .day, value: days, to: start)!
        
        var add = self.getEventsFromCalendar(start: start, end: end)
     
        if saCals != HLLDefaults.calendar.enabledCalendars {
            saCals = HLLDefaults.calendar.enabledCalendars
            
        }
        
        
        addPinnedTo(with: &add)

            FollowingOccurenceStore.shared.updateNextOccurenceDictionary(events: add)
        
 
            HLLHiddenEventStore.shared.updateHiddenEvents(from: add)
            
            var key = [Date]()
            
            let soon = self.fetchEventsFromPresetPeriod(period: .AllTodayPlus24HoursFromNow)
            for event in soon {
                key.append(event.startDate)
                key.append(event.endDate)
            }
        
            self.eventPoolKeyDates = key
            
        
    
        
        
        if HLLDefaults.general.showAllDay == false {
        
            add = add.filter { !$0.isAllDay }
            
        }
        
        let previousEventPool = self.eventPool
        
        add.append(contentsOf: dummyGen.events)
        
        add = remover.removeDoublesIn(events: add)
        
        add = NicknameManager.shared.addNicknames(for: add)
        
        self.eventPool = add
        
        /*if let encoded = try? JSONEncoder().encode(add) {
          //  HLLDefaults.defaults.set(encoded, forKey: "EncodedEventPool")
        } */
        
        eventPoolUpdatingCounter -= 1
        HLLEventSource.updatingEventPool = false
        
        
        updateHiddenEvents()
        
        
           
        let prevNeverUpdated = neverUpdatedEventPool
        
        self.neverUpdatedEventPool = false
        
       /* if HLLDefaults.calendar.enabledCalendars.count == 0 {
            self.eventPool.removeAll()
        } */
        
        if previousEventPool != self.eventPool {
        
        notifyEventPoolUpdateObservers()
            
        } else {
            
            if prevNeverUpdated {
                notifyEventPoolUpdateObservers()
            }
            
        }
        

        
        print("Updated event pool with \(self.eventPool.count) events, in \(CurrentDateFetcher.currentDate.timeIntervalSince(eventPoolUpdateStart))s")

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
    
    func updateEventPoolPinned() {

        
            var events = self.eventPool
            self.addPinnedTo(with: &events)
            self.eventPool = events
            updateHiddenEvents()
            notifyEventPoolUpdateObservers()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        
            print("Async trigger 2")
            self.asyncUpdateEventPool()
            
        }
            
        
        
    }
    
    func updateHiddenEvents() {
        
        #if os(macOS)
        
        if ProStatusManager.shared.isPro == false {
            return
        }
        
        #endif
         
         let ids = HLLHiddenEventStore.shared.hiddenEvents.compactMap({$0.identifier})
        
        self.eventPool = eventPool.filter({ event in
                   
                   if let ekID = event.eventIdentifier {
                        
                        if ids.contains(ekID) { return false }
                                  
                   } else {
                    
                        if ids.contains(event.persistentIdentifier) { return false }
                    
                    }
                   
                   return true
                   
               })
        

    }
    
    @objc func eventPoolCooldownEnded() {
        
        if eventPoolUpdateRequestedDuringCooldown {
            updateEventPool()
        }
        
        eventPoolUpdateRequestedDuringCooldown = false
        
    }
    
    func getCalendars() -> [EKCalendar] {
  
        let cals = eventStore.calendars(for: .event)
        //print("\(cals) fetched")
        return cals
    }
    
    func getCalendarIDS() -> [String] {
        return getCalendars().map { $0.calendarIdentifier }
        
    }
    
    func getEventsFromEventPool(start: Date, end: Date, includeHidden: Bool = false) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        if neverUpdatedEventPool {
            
            return returnArray
            
        }
        
        let poolEvents = eventPool
        
        for event in poolEvents {
            
            if event.startDate.timeIntervalSince(end) < 0, event.endDate.timeIntervalSince(start) > 0 {
                
                if HLLHiddenEventStore.shared.hiddenEvents.contains(where: { $0.identifier == event.persistentIdentifier }) {
                    
                    if !includeHidden {
                        
                        continue
                        
                    }
                    
                }

                
                returnArray.append(event)
                
            }
            
            
        }
        
        
        returnArray.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        
        
        return returnArray
        
    }
    
    let readQueue = DispatchQueue(label: "readQueue")
    
    func getEventsFromCalendar(start: Date, end: Date, useCalendar: EKCalendar? = nil) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
      
        
        if HLLDefaults.calendar.enabledCalendars.isEmpty, HLLDefaults.calendar.disabledCalendars.isEmpty {
            HLLDefaults.calendar.enabledCalendars = getCalendarIDS()
        }
            
        let enabledIDS = HLLDefaults.calendar.enabledCalendars
        let allCalendars = getCalendars()
            
        var calendars = [EKCalendar]()
        var disabledCalendars = [EKCalendar]()
            
            if let cal = useCalendar {
                
                calendars = [cal]
                
            } else {
        
        for calendar in allCalendars {
            
            if enabledIDS.contains(calendar.calendarIdentifier) {
                
                calendars.append(calendar)
                
            } else if HLLDefaults.calendar.useNewCalendars, !HLLDefaults.calendar.disabledCalendars.contains(calendar.calendarIdentifier) {
                
                calendars.append(calendar)

            } else {
                
                disabledCalendars.append(calendar)
            }
                
            
        }
        
        HLLDefaults.calendar.enabledCalendars = calendars.map {$0.calendarIdentifier}
        HLLDefaults.calendar.disabledCalendars = disabledCalendars.map {$0.calendarIdentifier}
        
            }
            
        var calendarEvents = [EKEvent]()
        
       
            
        let predicate = self.eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            
        calendarEvents = eventStore.events(matching: predicate)

     
            
        for event in calendarEvents {
            
            returnArray.append(HLLEvent(event))
        }
        
        
        
        if HLLDefaults.calendar.enabledCalendars.isEmpty, !HLLDefaults.calendar.disabledCalendars.isEmpty {
            returnArray.removeAll()
        }
        
        return returnArray
    }
    
    func getPinnedEvents() -> [HLLEvent] {
        
        var returnEvents = [HLLEvent]()
        
        for identifier in HLLDefaults.general.pinnedEventIdentifiers {
            
            if let calEvent = eventStore.event(withIdentifier: identifier) {
                
                var event = HLLEvent(calEvent)
                
                event.isUserHideable = false
                returnEvents.append(event)
                
            }
            
        }
        
        return returnEvents
        
    }
    
   /* func getTrials() -> [HLLEvent] {
        
        let trials = trialsFetcher.getTrialsExams()
        let events = trials.map({$0.asHLLEvent()})
        return events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
    } */
    
    func eventStoreContainsEvent(with identifier: String) -> Bool {
        
        return eventStore.event(withIdentifier: identifier) != nil
        
    }
    
    func eventStoreEvent(withIdentifier: String) -> HLLEvent? {
        
        if let event = eventStore.event(withIdentifier: withIdentifier) {
            return HLLEvent(event)
        }
        
        return nil
        
    }
    
    
    func findEventWithIdentifier(id: String) -> HLLEvent? {
    
        if let event = eventPool.first(where: {
            
            
            return $0.persistentIdentifier == id}) {

            return event
            
        } else {
            
            return eventPool.first(where: {$0.persistentIdentifier == id})
        }

        
    }
    
    func findEventWithAppIdentifier(id: String) -> HLLEvent? {
        
        return eventPool.first(where: {$0.persistentIdentifier == id})

        
    }
    
    func findEventsWithAppIdentifier(ids: [String]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        for id in ids {
            
            returnArray.append(contentsOf: eventPool.filter({$0.persistentIdentifier == id }))
        }

        return returnArray
        
    }
    
    
    func fetchEventsOnDay(day: Date) -> [HLLEvent] {
        
        let start = day.startOfDay()
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        return getEventsFromCalendar(start: start, end: end!)
        
    }
    
    func fetchEventsOnDays(days: [Date]) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        for day in days {
            
            returnArray.append(contentsOf: fetchEventsOnDay(day: day))
            
        }
        
        returnArray.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        
        return returnArray
        
    }
    
    
    func fetchEventsFromPresetPeriod(period: EventFetchPeriod) -> [HLLEvent] {
        
        // Returns an array of all calendar events occuring in the specified period.
        
        var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: CurrentDateFetcher.currentDate)
        comp.timeZone = TimeZone.current
        
        var startDate: Date?
        var endDate: Date?
        
        switch period {
        case .AllToday:
            
            // Return all calendar events occuring today.
            
            startDate = NSCalendar.current.date(from: comp)!
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
            
        case .UpcomingToday:
            
            // Return all calendar events occuring today that have not already started.
            
            startDate = CurrentDateFetcher.currentDate
            endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
            
        case .AllTodayPlus24HoursFromNow:
            
            // Return all calendar events occuring in the next 24 hours.
            
            startDate = CurrentDateFetcher.currentDate.startOfDay()
            endDate = startDate?.addingTimeInterval(86400)
            
        case .Next2Weeks:
            
            startDate = NSCalendar.current.date(from: comp)!
            endDate = Calendar.current.date(byAdding: .day, value: 14, to: startDate!)
            
            
        case .AnalysisPeriod:
            
            // Return all calendar events from 2 days ago to 2 days from now.
            
            startDate = NSCalendar.current.date(from: comp)!.addingTimeInterval(-604800)
            endDate = NSCalendar.current.date(from: comp)!.addingTimeInterval(604800)
            
        case .ThisYear:
            
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: CurrentDateFetcher.currentDate)))!
            
            endDate = Calendar.current.date(byAdding: DateComponents(year: 1), to: startDate!)!
            
            
            
        case .OneMonthEachSideOfToday:
            
            startDate = NSCalendar.current.date(from: comp)!.addingTimeInterval(-2592000)
            endDate = NSCalendar.current.date(from: comp)!.addingTimeInterval(2592000)
            
        }
        
        
        return getEventsFromEventPool(start: startDate!, end: endDate!)
        
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
            return getUpcomingEventsFromNextDayWithEvents().first
        }
        
        let current = getCurrentEvents(includeHidden: false).first
        
        if HLLDefaults.statusItem.eventMode == .currentOnly {
            return current
        }
          
        let upcoming = getUpcomingEventsFromNextDayWithEvents().first
        
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
    
    func getCurrentEvents(includeHidden: Bool = false, includeSelected: Bool = true) -> [HLLEvent] {
        
        var currentEvents = [HLLEvent]()
        
        for event in self.eventPool {
            
            if event.completionStatus == .current && (!HLLHiddenEventStore.shared.isHidden(event: event) || includeHidden)  {
                
  
                if (includeSelected == false && event.isSelected) {
                    continue
                }
                
                currentEvents.append(event)
 
                
            }
        }
        
        
        currentEvents.sort(by: { $0.endDate.compare($1.endDate) == .orderedAscending })
        
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
    
    func getPinnedEventsFromEventPool() -> [HLLEvent] {
        
        return eventPool.filter({$0.isPinned})
        
    }
    
    func getRecentlyEndedEvents() -> [HLLEvent] {
        
        let events = eventPool.filter { $0.completionStatus == .done && $0.endDate.timeIntervalSince(CurrentDateFetcher.currentDate) > -300 }
        return events.sorted(by: { $0.endDate.compare($1.endDate) == .orderedDescending })
        
    }
    
    func getNextUpcomingEvent() -> HLLEvent? {
        
        return getUpcomingEventsFromNextDayWithEvents().first
        
    }
    
    func getUpcomingEvents(limit: Int) -> [HLLEvent] {
        
        var allUpcoming = eventPool.filter({$0.completionStatus == .upcoming})
        allUpcoming.sort(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        return Array(allUpcoming.prefix(limit))
        
    }
    
    func getUpcomingEventsToday() -> [HLLEvent] {
        
        let eventsToday = fetchEventsFromPresetPeriod(period: EventFetchPeriod.AllToday)
        
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
        events.append(contentsOf: getUpcomingEventsFromNextDayWithEvents(includeStarted: false))
        }
         
        if chronological {
        events.sort(by: { $0.countdownDate.compare($1.countdownDate) == .orderedAscending })
        }
        
        //print("Get timeline returning \(events.count) events")
        
        return events
        
    }

    func getUpcomingEventsFromNextDayWithEvents(includeStarted: Bool = false, date: Date = Date()) -> [HLLEvent] {
        
        var upEvents = [HLLEvent]()
        var returnEvents = [HLLEvent]()
        
        var comp: DateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: date)
        comp.timeZone = TimeZone.current
        var loopStart = NSCalendar.current.date(from: comp)!
        var loopEnd = Calendar.current.date(byAdding: .day, value: 1, to: loopStart)
        
        outer: for _ in 1...7 {
            
            upEvents = getEventsFromEventPool(start: loopStart, end: loopEnd!)
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
      
        
        return returnEvents.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
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
            
            var events = getEventsFromEventPool(start: loopStart, end: loopEnd).sorted(by: {
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
    
    func getAllEventsGroupedByDate() -> [DateOfEvents] {
        
        let dict = Dictionary(grouping: eventPool, by: { $0.startDate.startOfDay() })
        
        var returnArray = [DateOfEvents]()
        
        for item in dict {
            returnArray.append(DateOfEvents(date: item.key, events: item.value))
        }
        
        return returnArray
        
    }
    
    func getArraysOfUpcomingEventsForNextSevenDays(returnEmptyItems: Bool, allowToday: Bool) -> [DateOfEvents] {
        
        var start = Date().startOfDay()
        if !allowToday {
            start = start.addDays(1)
        }
        let end = start.addDays(7)
        
       return getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: returnEmptyItems)
        
    }
    
    func ekEvent(with id: String?) -> EKEvent? {
        
        if let id = id {
            return self.eventStore.event(withIdentifier: id)
        }
        return nil
        
    }
    
    func calendarFromID(_ id: String?) -> EKCalendar? {
        
        if let safeId = id {
            
            return self.eventStore.calendar(withIdentifier: safeId)
            
        }
        
        return nil
        
    }
    
    func addEventPoolObserver(_ observer: EventPoolUpdateObserver, immediatelyNotify: Bool = false) {
        
        self.eventPoolObservers.append(observer)
        
        if immediatelyNotify, !neverUpdatedEventPool {
            observer.eventPoolUpdated()
        }
        
        
       // print("There are now \(self.eventPoolObservers.count) evnent pool update observers.")
        
       
        
    }
    
    func notifyEventPoolUpdateObservers() {
        
        self.eventPoolObservers.forEach { observer in
                
            DispatchQueue.global(qos: .userInteractive).async {
                
                observer.eventPoolUpdated()
            }
                
        }
        
    }
    
}

protocol CalendarAccessStateDelegate {
    func calendarAccessDenied()
}


protocol EventPoolUpdateObserver {
    
    func eventPoolUpdated()
    
}

public class SynchronizedArray<T> {
private var array: [T] = []
private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)

public func append(newElement: T) {

    self.accessQueue.async(flags:.barrier) {
        self.array.append(newElement)
    }
}

public func removeAtIndex(index: Int) {

    self.accessQueue.async(flags:.barrier) {
        self.array.remove(at: index)
    }
}

public var count: Int {
    var count = 0

    self.accessQueue.sync {
        count = self.array.count
    }

    return count
}

public func first() -> T? {
    var element: T?

    self.accessQueue.sync {
        if !self.array.isEmpty {
            element = self.array[0]
        }
    }

    return element
}

public subscript(index: Int) -> T {
    
        set {
            self.accessQueue.async(flags:.barrier) {
                self.array[index] = newValue
            }
        }
        get {
            var element: T!
            self.accessQueue.sync {
                element = self.array[index]
            }

            return element
        }
    }
    
}

extension Date {
    
    func addDays(_ days: Int) -> Date {
        
        Calendar.current.date(byAdding: .day, value: days, to: self)!
        
    }
    
}
