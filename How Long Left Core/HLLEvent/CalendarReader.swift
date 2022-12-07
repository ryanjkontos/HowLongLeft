//
//  CalendarReader.swift
//  How Long Left
//
//  Created by Ryan Kontos on 21/10/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class CalendarReader {
    
    static var shared = CalendarReader()
    
    
    
    var eventStore = EKEventStore()
    var calendarAccess: CalendarAccessState = .Unknown
    

    
    
    func getEventsFromCalendar(start: Date, end: Date) -> [HLLEvent] {
        
        #if os(iOS)
            eventStore.refreshSourcesIfNecessary()
        #endif
        
        let calendars = CalendarDefaultsModifier.shared.getEnabledCalendars()
        let predicate = self.eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        return eventStore.events(matching: predicate).map({ HLLEvent($0) })
     
    }
    
    func getCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }
    
    func getCalendarIDS() -> [String] {
        return getCalendars().map { $0.title }
    }
        
    func getCalendarAccess() async {
        
        do {
            
            let result = try await eventStore.requestAccess(to: .event)
            
            self.eventStore = EKEventStore()
            self.eventStore.reset()
            
            if result == true {
                self.calendarAccess = .Granted
            } else {
                self.calendarAccess = .Denied
            }

            HLLEventSource.shared.updateEvents(full: false)
            
        } catch {
            // print("Cal access error: \(error)")
        }
        
        
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
    
    func eventStoreContainsEvent(with identifier: String) -> Bool {
        return eventStore.event(withIdentifier: identifier) != nil
    }
    
    func eventStoreEvent(withIdentifier: String) -> HLLEvent? {
        
        if let event = eventStore.event(withIdentifier: withIdentifier) {
            return HLLEvent(event)
        }
        
        return nil
        
    }
    
}
