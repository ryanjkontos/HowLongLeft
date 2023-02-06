//
//  CustomCalendarEventSource.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/1/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class ComplicationEventStore: HLLEventSource {
    
    static var sharedComplicationStore = ComplicationEventStore()
    
    override init() {
        super.init()
        calendarFetcher = {
            
            return CalendarDefaultsModifier.complicationCurrent.getEnabledCalendars()
              
          }
    }
    
   
    
    
}
