//
//  HWEventFinder.swift
//  How Long Left
//
//  Created by Ryan Kontos on 5/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class HWEventFinder {
    
    static var shared = HWEventFinder()
    
    private static let eventName = "Hannah Work"
    private static let calendarName = "Hannah Work"
    private static let locationName = "Krispy Kreme Auburn"
    
    private let defaultsKey = "IsHWUser"
    
    var hasFoundHWEvent: Bool
    
    var hwCalendar: EKCalendar?
    
    private var onEventFound: ((Bool) -> Void)?

    init(onEventFound: ((Bool) -> Void)? = nil) {
        self.onEventFound = onEventFound
        hasFoundHWEvent = HLLDefaults.defaults.bool(forKey: defaultsKey)
        if hasFoundHWEvent {
            onEventFound?(true)
        }
       
       
    }

     func checkForHWEvent(from events: [HLLEvent]) {
        
        print("Checking HW")
        
        let calendars = CalendarReader.shared.getCalendars()
        guard !calendars.isEmpty else { return }
        
       
        guard !events.isEmpty else { return }
        
        guard let cal = HWEventFinder.getHWCalendar() else {
            setEventFound(false)
            return
        }
        
        self.hwCalendar = cal
        
        for event in events {
            
            guard let calendar = event.calendar else { continue }
            
            if calendar == cal, event.title == HWEventFinder.eventName, event.location == HWEventFinder.locationName {
                setEventFound(true)
                return
            }
        }
        
        setEventFound(false)
        
    }
    
    func setEventFound(_ found: Bool) {
        
        let previousState = hasFoundHWEvent
        if found != previousState {
            self.onEventFound?(found)
        }
        
        hasFoundHWEvent = found
        HLLDefaults.defaults.set(found, forKey: defaultsKey)
        
        
    }
    
    static func getHWCalendar() -> EKCalendar? {
        return CalendarReader.shared.eventStore.calendars(for: .event).first(where: { $0.title == calendarName })
    }
    
  /*  func getAllHWEvents() -> [HLLEvent] {
        
        return HLLEventSource.shared.events.filter({ event in
            
            guard let calendar = event.calendar else { return false }
            return (calendar.title == calendarName && event.title == eventName && event.location == locationName)
            
        })
        
        
    }
    
    func groupShiftsByWeek(shifts: [HWShift]) -> [HWShiftWeek] {
        var shiftsByWeek: [Date: [HWShift]] = [:]

        // Iterate over the shifts and group them by the week they occur in
        for shift in shifts {
            let startWeek = shift.start.getMondayOfWeek()
            if shiftsByWeek[startWeek] == nil {
                shiftsByWeek[startWeek] = [shift]
            } else {
                shiftsByWeek[startWeek]!.append(shift)
            }
        }

        // Convert the dictionary to an array of tuples and sort it by the start date of the week
        let shiftsByWeekArray = shiftsByWeek.map { (weekStart, shifts) -> HWShiftWeek in
            return HWShiftWeek(weekOf: weekStart, shifts: shifts)
        }
        let sortedShiftsByWeekArray = shiftsByWeekArray.sorted { (t1, t2) -> Bool in
            return t1.weekOf < t2.weekOf
        }

        return sortedShiftsByWeekArray
    } */

    
    
}

