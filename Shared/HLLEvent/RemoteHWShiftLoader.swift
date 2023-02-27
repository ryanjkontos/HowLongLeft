//
//  RemoteHWShiftLoader.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 7/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

import GoogleAPIClientForRESTCore
import GoogleAPIClientForREST_Calendar
#if os(watchOS)
import WatchKit
#endif

class RemoteHWShiftLoader {
    
    
    private var shifts = [HWShift]()
    
    init() {
        load()
    }
    
    func load() {
        
        #if os(watchOS)
        if WKApplication.shared().applicationState != .active {
            return
        }
        #endif
        
        if HWEventFinder.shared.hasFoundHWEvent == false {
            return
        }
        
        let now = Date()
        let aWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let twoWeeksFromNow = Calendar.current.date(byAdding: .day, value: 14, to: now)!
        
        let calendarService = GTLRCalendarService()
        calendarService.apiKey = PrivateKeys.googleKey
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: PrivateKeys.hwCalID)
        query.timeMin = GTLRDateTime(date: aWeekAgo)
        query.timeMax = GTLRDateTime(date: twoWeeksFromNow)
        calendarService.executeQuery(query) { (ticket, events, error) in
          if let error = error {
            print("HWError: \(error.localizedDescription)")
          } else if let eventsObject = events as? GTLRCalendar_Events {
              
            guard let eventsArray = eventsObject.items else { return }
            
              let prev = self.shifts
              
              self.shifts = eventsArray.map({ HWShift(start: $0.start!.dateTime!.date, end: $0.end!.dateTime!.date) })
              
              if self.shifts != prev {
                  HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
              }
             
              
          }
        }
        
    }
    
    func addShiftEvents(to events: inout [HLLEvent]) {
        
      
        guard HWEventFinder.shared.hasFoundHWEvent else { return }
        
        guard let calendar = HWEventFinder.getHWCalendar() else { return }
        
        if shifts.isEmpty { return }
        
        var shiftsToAdd = shifts
        print("HW Starting with \(shiftsToAdd.count) shifts")
        
        shiftsToAdd = shiftsToAdd.filter { shift in
            return shift.end > Date()
        }
        
        for event in events {
            shiftsToAdd.removeAll(where: { $0.start == event.startDate && $0.end == event.endDate })
        }
        
        print("HW Ending with \(shiftsToAdd.count) shifts")
        
        events.append(contentsOf: shiftsToAdd.map({ var event = HLLEvent(title: "Hannah Work", start: $0.start, end: $0.end, location: "Krispy Kreme Auburn")
        event.calendarID = calendar.calendarIdentifier
            event.isRemote = true
        return event
            
        }))
        
        
    }
    
}




