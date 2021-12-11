//
//  SchoolHolidayEventFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 19/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolHolidayEventFetcher {
    
    let holidaysStore = SchoolHolidayPeriodsStore()
    
    var currentTerm: Int? {
        
        get {
            
            return self.getCurrentHolidays()?.holidaysTerm
            
            
        }
    }
    
    func getHolidays() -> [HLLEvent] {
        
        return getSchoolHolidaysFrom(start: CurrentDateFetcher.currentDate, end: Date.distantFuture)
        
    }
    
    func getCurrentHolidays() -> HLLEvent? {
        

        for event in getHolidays() {
            
            if event.completionStatus == .current {
                
                return event
                
            }
            
        }
        
        return nil
    }
    
    func getUpcomingHolidays() -> HLLEvent? {
        
        return getSchoolHolidaysFrom(start: CurrentDateFetcher.currentDate, end: Date.distantFuture, excludeOnNow: true).first
        
        
    }
    
    func getPreviousHolidays() -> HLLEvent? {
        
        if SchoolAnalyser.schoolMode != .Magdalene {
            return nil
        }
        
        var endedArray = [HLLEvent]()
        
        for holidayPeriod in holidaysStore.holidayPeriods {
            
            if holidayPeriod.start.timeIntervalSince(CurrentDateFetcher.currentDate) < 0 {
                
                endedArray.append(createHolidaysHLLEvent(from: holidayPeriod))
                
            }
            
            
            
        }
        
        return endedArray.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending }).last
        
        
    }
    
    func getSchoolHolidaysFrom(start: Date, end: Date, excludeOnNow: Bool = false) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        if SchoolAnalyser.schoolMode != .Magdalene {
            return returnArray
        }
        
        for holidayPeriod in holidaysStore.holidayPeriods {
            
            if holidayPeriod.start.timeIntervalSince(end) < 0, holidayPeriod.end.timeIntervalSince(start) > 0 {
                
                let event = createHolidaysHLLEvent(from: holidayPeriod)
                
                if event.completionStatus == .current {
                    
                    if excludeOnNow == true {
                        
                        continue
                        
                    }
                    
                }
                
                returnArray.append(event)
            
            }
        }
        
        return returnArray.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
    }
    
    func createHolidaysHLLEvent(from period: SchoolHolidaysPeriod) -> HLLEvent {
        
        var holidaysEvent = HLLEvent(title: "Holidays", start: period.start, end: period.end, location: nil)
        holidaysEvent.titleReferencesMultipleEvents = true
        holidaysEvent.isUserHideable = false
        holidaysEvent.holidaysTerm = period.term
        holidaysEvent.associatedCalendar = SchoolAnalyser.schoolCalendar
        holidaysEvent.visibilityString = .holidays
        return holidaysEvent
    }
    
    
}
