//
//  EnabledCalendarsManager.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit
import Combine

class EnabledCalendarsManager: ObservableObject {

    @Published var allCalendars = [IdentifiableCalendar]()
    
    @Published private(set) var allEnabled = false
    
    var toggleAction: ((EKCalendar, Bool) -> ())
    fileprivate var toggledCheck: ((EKCalendar) -> (Bool))
    
    internal init(toggleAction: @escaping ((EKCalendar, Bool) -> ()), toggledCheck: @escaping ((EKCalendar) -> (Bool))) {
        self.toggleAction = toggleAction
        self.toggledCheck = toggledCheck
        
        update()
    }

    
    var enabledCount: Int {
        get {
            return allCalendars.filter({$0.enabled}).count
        }
    }
    
    func update() {
        
        allCalendars = CalendarReader.shared.getCalendars().map { IdentifiableCalendar(delegate: self, calendar: $0, enabled: toggledCheck($0)) }
        var allEnabled = true
        for cal in allCalendars {
            if cal.enabled == false {
                allEnabled = false
            }
        }
        
        
        self.allEnabled = allEnabled
    }
    
    func toggleAll() {
        
        let newState = !allEnabled
        for calendar in allCalendars {
            calendar.enabled = newState
        }
        
        update()
        
        HLLEventSource.shared.updateEventsAsync()
    }
    
    
    
}


