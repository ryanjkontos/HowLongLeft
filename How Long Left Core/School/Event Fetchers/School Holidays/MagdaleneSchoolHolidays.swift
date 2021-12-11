//
//  SchoolHolidayPeriodsStore.swift
//  How Long Left
//
//  Created by Ryan Kontos on 1/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolHolidayPeriodsStore {
    
    var holidayPeriods = [SchoolHolidaysPeriod]()
    
    init() {
        
        let start = NSDateComponents()
        let end = NSDateComponents()
        
        // Term 4 Holidays 2019
        
        start.year = 2019
        start.month = 12
        start.day = 13
        start.hour = 14
        start.minute = 35
        start.second = 00
        
        end.year = 2020
        end.month = 1
        end.day = 30
        end.hour = 0
        end.minute = 0
        end.second = 00
        holidayPeriods.append(SchoolHolidaysPeriod(startComp: start, endComp: end, term: 4))
        
        // Term 1 Holidays 2020
        
        start.year = 2020
        start.month = 4
        start.day = 9
        start.hour = 14
        start.minute = 35
        start.second = 00
        
        end.year = 2020
        end.month = 4
        end.day = 27
        end.hour = 0
        end.minute = 0
        end.second = 00
        holidayPeriods.append(SchoolHolidaysPeriod(startComp: start, endComp: end, term: 1))
        
        // Term 2 Holidays 2020
        
        start.year = 2020
        start.month = 7
        start.day = 3
        start.hour = 14
        start.minute = 35
        start.second = 00
        
        end.year = 2020
        end.month = 7
        end.day = 20
        end.hour = 0
        end.minute = 0
        end.second = 00
        holidayPeriods.append(SchoolHolidaysPeriod(startComp: start, endComp: end, term: 2))
        
        // Term 3 Holidays 2020
        
        start.year = 2020
        start.month = 9
        start.day = 25
        start.hour = 14
        start.minute = 35
        start.second = 00
        
        end.year = 2020
        end.month = 10
        end.day = 12
        end.hour = 0
        end.minute = 0
        end.second = 00
        holidayPeriods.append(SchoolHolidaysPeriod(startComp: start, endComp: end, term: 3))
        
        
        
    }
    
}
