//
//  SchoolEventDownloadNeededEvaluator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 24/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolEventDownloadNeededEvaluator {
    
    let schoolHolidaysFetcher = SchoolHolidayEventFetcher()
    let termFetcher = TermEventFetcher()
    let schoolAnalyser = SchoolAnalyser()
    
    func evaluateSchoolEventDownloadNeeded() -> SchoolEventDownloadNeededStatus {
        
        
        if SchoolAnalyser.schoolMode == .Magdalene {
            
            var schoolCondition = false
            
            if termFetcher.getCurrentTermEvent() != nil {
                schoolCondition = true
            } else {
                if let holidays = schoolHolidaysFetcher.getCurrentHolidays() {
                    if holidays.endDate.timeIntervalSince(CurrentDateFetcher.currentDate) < 172800 {
                        schoolCondition = true
                    }
                }
            }
            
            if schoolCondition {
                
                if schoolAnalyser.magdaleneTitles(from: HLLEventSource.shared.eventPool, includeRenamed: true).isEmpty {
                    
                    return .neededDueToPastInstall
                    
                }
                
                
            }
            
        } else {
            
            if MagdaleneWifiCheck.shared.isOnMagdaleneWifi() {
                return .neededDueToMagdaleneWifi
            }
            
        }
        
        return .notNeeded
        
        
    }
    
}

enum SchoolEventDownloadNeededStatus {
    
    case notNeeded
    case neededDueToMagdaleneWifi
    case neededDueToPastInstall
    
}
