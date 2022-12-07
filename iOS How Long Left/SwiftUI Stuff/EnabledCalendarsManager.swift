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
    
    fileprivate var toggleAction: ((EKCalendar, Bool) -> ())
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

class IdentifiableCalendar: Identifiable, Equatable {
    
    
    internal init(delegate: EnabledCalendarsManager, calendar: EKCalendar, enabled: Bool = false) {
        self.delegate = delegate
        self.calendar = calendar
        self.enabled = enabled
    }
    
    var id: String {
        get {
            return "\(calendar.calendarIdentifier)"
        }
    }
    
    var delegate: EnabledCalendarsManager
    var calendar: EKCalendar
    var enabled: Bool = false {
        
        didSet {
            
            delegate.toggleAction(self.calendar, enabled)
            delegate.update()
            
            HLLEventSource.shared.updateEventsAsync()
            
        }
    }
    
    static func == (lhs: IdentifiableCalendar, rhs: IdentifiableCalendar) -> Bool {
        lhs.id == rhs.id
    }
    
}

extension EKCalendar {
    
    var isToggled: Bool {
        get {
            return HLLDefaults.calendar.enabledCalendars.contains(where: {$0 == self.calendarIdentifier})
        }
    }
    
}

class AppEnabledCalendarsManager: EnabledCalendarsManager {
    
    static var shared = AppEnabledCalendarsManager()
    
    convenience init() {
        
        self.init(toggleAction: { (calendar, enabled) in
            
            CalendarDefaultsModifier.shared.setState(enabled: enabled, calendar: calendar)
           
            
        }, toggledCheck: { $0.isToggled })
        
    }
    
}
