//
//  SchoolEventFetcher.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 27/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolEventFetcher {
  
    func getSchoolEvent() -> HLLEvent? {
        
        let today = CurrentDateFetcher.currentDate
        
        let start = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(bySettingHour: 8, minute: 15, second: 0, of: today, options: .matchFirst))!
        
        let end = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(bySettingHour: 14, minute: 35, second: 0, of: today, options: .matchFirst))!

        var event = HLLEvent(title: "School", start: start, end: end, location: nil)
        event.isHidden = true
        event.associatedCalendar = SchoolAnalyser.schoolCalendar
        
        if event.completionStatus != .upcoming {
            return event
        }
        
        return nil
        
        
    }
    
}
