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
    
    init() {
        
        
        update()
    }
    
    var enabledCount: Int {
        
        get {
            
            return allCalendars.filter({$0.enabled}).count
            
        }
        
    }
    
    var useNewCalendars: Bool = HLLDefaults.calendar.useNewCalendars {
        
        willSet {
            
            HLLDefaults.calendar.useNewCalendars = newValue
            objectWillChange.send()
            
        }
        
    }
    
    func update() {
        
        allCalendars = HLLEventSource.shared.getCalendars().map { IdentifiableCalendar(delegate: self, calendar: $0, enabled: $0.isToggled) }
        
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
        
    }
    
    
    
}

class IdentifiableCalendar: Identifiable {
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
            CalendarDefaultsModifier.shared.setState(enabled: enabled, calendar: calendar)
            delegate.update()
            
            DispatchQueue.main.async {
                HLLEventSource.shared.updateEventPool()
            }
            
        }
    }
    
}

extension EKCalendar {
    
    var isToggled: Bool {
        get {
            return HLLDefaults.calendar.enabledCalendars.contains(where: {$0 == self.calendarIdentifier})
        }
    }
    
}
