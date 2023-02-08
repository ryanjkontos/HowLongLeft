//
//  CalendarReader.swift
//  How Long Left
//
//  Created by Ryan Kontos on 21/10/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit
import os.log

class CalendarReader {
    
    
    
    static var shared = CalendarReader()
    
    
    static let logger = Logger(subsystem: "CalendarReader", category: "Info")
    
    var eventStore = EKEventStore()
    var calendarAccess: CalendarAccessState = .Unknown
    

    let eventFetchQueue = DispatchQueue(label: "EventFetchQueue", qos: .default)
    let calendarFetchQueue = DispatchQueue(label: "CalendarFetchQueue", qos: .userInteractive)
    
    
    init() {
        
        Task {
            await CalendarReader.shared.getCalendarAccess()
        }
        
    }
    
    func getEventsFromCalendar(start: Date, end: Date, usingCalendars calendars: [EKCalendar]) -> [HLLEvent] {
        
        eventFetchQueue.sync {
            
            CalendarReader.logger.log("Asking calendar for events between \(start) and \(end) from \(calendars.count) calendar(s)")
            
            let predicate = self.eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
            return eventStore.events(matching: predicate).map({ HLLEvent($0) })
            
        }
     
    }
    
    func getCalendars() -> [EKCalendar] {
        calendarFetchQueue.sync {
            return eventStore.calendars(for: .event)
        }
    }
    
    func getCalendarIDS() -> [String] {
        return getCalendars().map { $0.title }
    }
        
    func getCalendarAccess() async {
        
        if self.calendarAccess == .Granted {
            return
        }
        
        print("EVS: Getting calendar access")
            
            do {
             //   CXLogger.log("Getting cal access")
                
                
                //eventStore.reset()
                let result = try await eventStore.requestAccess(to: .event)
                
               print("EVS: Got calendar access")
                
                if result == true {
                    self.calendarAccess = .Granted
                } else {
                    self.calendarAccess = .Denied
                }
                
          //      CXLogger.log("Got cal access: \(self.calendarAccess == .Granted)")
                
                HLLEventSource.shared.updateEvents(full: false, bypassDebouncing: true)
                
            } catch {
                 print("Cal access error: \(error)")
              //  CXLogger.log("Cal access error \(error)")
            }
            
        
       
        
    }
    
    
    func ekEvent(with id: String?) -> EKEvent? {
        
        eventFetchQueue.sync {
            
            
            if let id = id {
                return self.eventStore.event(withIdentifier: id)
            }
            return nil
            
        }
        
    }
    
    func calendarFromID(_ id: String?) -> EKCalendar? {
        
        calendarFetchQueue.sync {
            
            
            if let safeId = id {
                
                return self.eventStore.calendar(withIdentifier: safeId)
                
            }
            
            return nil
            
        }
        
    }
    
    func eventStoreContainsEvent(with identifier: String) -> Bool {
        eventFetchQueue.sync {
            return eventStore.event(withIdentifier: identifier) != nil
        }
        
    }
    
    func eventStoreEvent(withIdentifier: String) -> HLLEvent? {
        
        eventFetchQueue.sync {
            
            if let event = eventStore.event(withIdentifier: withIdentifier) {
                return HLLEvent(event)
            }
            
            return nil
            
        }
        
    }
    
}
