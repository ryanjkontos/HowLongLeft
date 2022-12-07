//
//  HideCalendarMenuItemHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 23/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import EventKit

class HideCalendarMenuItemHandler {
    
    static var shared = HideCalendarMenuItemHandler()
    
    @objc func hideCalendarFor(sender: NSMenuItem) {
        
        DispatchQueue.main.async {
        
        if let calendar = sender.representedObject as? EKCalendar {
            
            CalendarDefaultsModifier.shared.toggle(calendar: calendar)
            HLLEventSource.shared.updateEventsAsync()
            
        }
            
        }
        
    }
    
    @objc func hideAllButCalendarFor(sender: NSMenuItem) {
        
        DispatchQueue.main.async {
        
        if let calendar = sender.representedObject as? EKCalendar {
            
            CalendarDefaultsModifier.shared.setAllDisabled()
            CalendarDefaultsModifier.shared.setEnabled(calendar: calendar)
            HLLEventSource.shared.updateEventsAsync()
            
        }
            
        }
        
    }
    
    
}
