//
//  IdentifiableCalendar.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/1/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

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
