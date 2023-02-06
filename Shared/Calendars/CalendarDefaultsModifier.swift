//
//  CalendarDefaultsModifier.swift
//  How Long Left
//
//  Created by Ryan Kontos on 21/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class CalendarDefaultsModifier {
    
    internal init(_ enabledKey: String, _ disabledKey: String) {
        self.enabledKey = enabledKey
        self.disabledKey = disabledKey
    }
    
    static var shared = CalendarDefaultsModifier("setCalendars", "disabledCalendars")
    
    static var complicationCurrent: CalendarDefaultsModifier {
        if HLLDefaults.complication.mirrorCalendars {
            return shared
        } else {
            return privateComplicationShared
        }
    }
    
    static let privateComplicationShared = CalendarDefaultsModifier("ComplicationEnabledCalendars", "ComplicationDisabledCalendars")
    
    let enabledKey: String
    let disabledKey: String
    
    var enabledCalendars: [String] {
        get {
            let array = (HLLDefaults.defaults.array(forKey: enabledKey) as? [String]) ?? [String]()
            print("Enabledcalcount \(enabledKey): \(array.count)")
            return array
        }
        set {
            print("Setting enabled for \(enabledKey): \(newValue)")
            HLLDefaults.defaults.set(newValue, forKey: enabledKey)
        }
    }
    
    var disabledCalendars: [String] {
        get {
            return HLLDefaults.defaults.stringArray(forKey: disabledKey) ?? [String]()
        }
        set {
            HLLDefaults.defaults.set(newValue, forKey: disabledKey)
        }
    }
    
    
    func getEnabledCalendars() -> [EKCalendar] {
        
        if enabledCalendars.isEmpty, disabledCalendars.isEmpty {
            enabledCalendars = CalendarReader.shared.getCalendarIDS()
        }
        
        if enabledCalendars.isEmpty, !disabledCalendars.isEmpty {
            return .init()
        }
        
        let enabledIDS = enabledCalendars
        let allCalendars = CalendarReader.shared.getCalendars()
        
        var calendars = [EKCalendar]()
        var disabledCalendarsArray = [EKCalendar]()
     
        for calendar in allCalendars {
            
            if enabledIDS.contains(calendar.calendarIdentifier) {
                calendars.append(calendar)
            } else if HLLDefaults.calendar.useNewCalendars, !disabledCalendars.contains(calendar.calendarIdentifier) {
                calendars.append(calendar)
            } else {
                disabledCalendarsArray.append(calendar)
            }
            
        }
        
        enabledCalendars = calendars.map {$0.calendarIdentifier}
        disabledCalendars = disabledCalendarsArray.map {$0.calendarIdentifier}
        
        return calendars
        
    }
    
    func setEnabled(calendar: EKCalendar) {
        setEnabledWith(identifier: calendar.calendarIdentifier)
    }
    
    func setDisabled(calendar: EKCalendar) {
        setDisabledWith(identifier: calendar.calendarIdentifier)
    }
    
    func toggle(calendar: EKCalendar) {
        toggleWith(identifier: calendar.calendarIdentifier)
    }
    
    func setEnabledWith(identifier: String) {
        
        if !enabledCalendars.contains(identifier) {
            enabledCalendars.append(identifier)
        }
             
        if let index = disabledCalendars.firstIndex(of: identifier) {
            disabledCalendars.remove(at: index)
        }
             
    }
    
    func setDisabledWith(identifier: String) {
        
        if let index = enabledCalendars.firstIndex(of: identifier) {
            enabledCalendars.remove(at: index)
        }
        
        if !disabledCalendars.contains(identifier) {
            disabledCalendars.append(identifier)
        }
        
    }
    
    func toggleWith(identifier: String) {
        
        if enabledCalendars.contains(identifier) {
            
            setDisabledWith(identifier: identifier)
            
        } else {
            
            setEnabledWith(identifier: identifier)
        }
        
    }
    
    func setState(enabled: Bool, calendar: EKCalendar) {
        
        if enabled == true {
            setEnabled(calendar: calendar)
        } else {
            setDisabled(calendar: calendar)
        }
        
    }
    
    func setState(enabled: Bool, identifier: String) {
        
        if enabled == true {
            setEnabledWith(identifier: identifier)
        } else {
            setDisabledWith(identifier: identifier)
        }
        
    }
    
    func setAllEnabled() {
        
        for calendar in CalendarReader.shared.getCalendars() {
            setEnabled(calendar: calendar)
        }
        
    }
    
    func setAllDisabled() {
        
        for calendar in CalendarReader.shared.getCalendars() {
            setDisabled(calendar: calendar)
        }
        
    }
    
    func toggleAllCalendars() {
        
        if allCalendarsEnabled() {
            setAllDisabled()
        } else {
            setAllEnabled()
        }
        
    }
    
    func isEnabled(_ cal: EKCalendar) -> Bool {
        
        return enabledCalendars.contains(where: { $0 == cal.calendarIdentifier })
        
    }
    
    func allCalendarsEnabled() -> Bool {
        
        if enabledCalendars.count == CalendarReader.shared.getCalendarIDS().count {
            return true
        } else {
            return false
        }
        
    }
    
    
}

