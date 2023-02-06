//
//  AppEnabledCalendarsManager.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/1/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation

class AppEnabledCalendarsManager: EnabledCalendarsManager {
    
    static var shared = AppEnabledCalendarsManager()
    
    convenience init() {
        
        self.init(toggleAction: { (calendar, enabled) in
            
            CalendarDefaultsModifier.shared.setState(enabled: enabled, calendar: calendar)
            
        }, toggledCheck: { CalendarDefaultsModifier.shared.isEnabled($0) })
        
    }
    
}
