//
//  CalendarTimeOffsetStore.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class CalendarTimeOffsetStore: ObservableObject {
    
    @Published var objects = [CalendarOffsetObject]()
    
    init() {
        
        objects = CalendarReader.shared.getCalendars().map({ CalendarOffsetObject(calendar: $0, offset: 0) })
        
    }
    
    struct CalendarOffsetObject: Identifiable {
        
        var id: String {
            return calendar.calendarIdentifier
        }
        
        var calendar: EKCalendar
        var offset: TimeInterval
    }
    
}
