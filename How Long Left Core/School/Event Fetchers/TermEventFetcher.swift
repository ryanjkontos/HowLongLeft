//
//  TermEventFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 19/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class TermEventFetcher {
    
    let holidaysFetcher = SchoolHolidayEventFetcher()
    
    func getCurrentTermEvent() -> HLLEvent? {
    
        var returnEvent: HLLEvent?
        
        if let previous = holidaysFetcher.getPreviousHolidays(), let next = holidaysFetcher.getUpcomingHolidays(), let termNumber = next.holidaysTerm {
            
            var termEvent = HLLEvent(title: "Term \(termNumber)", start: previous.endDate, end: next.startDate, location: nil)
            termEvent.isHidden = true
            termEvent.isTerm = true
            termEvent.visibilityString = VisibilityString.term

            
            termEvent.associatedCalendar = SchoolAnalyser.schoolCalendar
            
            if termEvent.completionStatus == .current {
            
            returnEvent = termEvent
            
            }
           
            
            
        }

        
        return returnEvent
        
    }
    
    
}
