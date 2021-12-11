//
//  KeyDateHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class KeyDateHandler: EventPoolUpdateObserver {
    
    static var shared = KeyDateHandler()
    
    var keyDates = [Date]()
    
    init() {
        HLLEventSource.shared.addEventPoolObserver(self)
    }
    
    func updateKeyDates() {
        
        let events = HLLEventSource.shared.fetchEventsFromPresetPeriod(period: .AllTodayPlus24HoursFromNow)
        
        var dateArray = [Date]()
        
        for event in events {
            dateArray.append(event.startDate)
            dateArray.append(event.endDate)
        }
        
    }
    
    func eventPoolUpdated() {
        updateKeyDates()
    }
    
}
