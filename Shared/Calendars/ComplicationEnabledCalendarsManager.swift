//
//  ComplicationEnabledCalendarsManager.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/1/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation

class ComplicationEnabledCalendarsManager: EnabledCalendarsManager {
    
    static var shared = ComplicationEnabledCalendarsManager()
    
    convenience init() {
        
        self.init(toggleAction: { (calendar, enabled) in
            
            CalendarDefaultsModifier.complicationCurrent.setState(enabled: enabled, calendar: calendar)
            
        }, toggledCheck: { CalendarDefaultsModifier.complicationCurrent.isEnabled($0) })
        
    }
    
}
