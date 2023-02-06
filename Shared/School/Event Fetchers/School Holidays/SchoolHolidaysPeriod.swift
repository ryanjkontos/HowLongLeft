//
//  SchoolHolidaysPeriod.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 19/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

struct SchoolHolidaysPeriod {
    
    init(startComp: NSDateComponents, endComp: NSDateComponents, term holidaysTerm: Int) {
        
        start = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: startComp as DateComponents))!
        end = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: endComp as DateComponents))!
        term = holidaysTerm
    }
    
    var start: Date
    var end: Date
    var term: Int
}
