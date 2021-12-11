//
//  MagdalenePeriods.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class MagdalenePeriods {
    
    func magdalenePeriodFor(events: [HLLEvent]) -> [HLLEvent] {
        
        // Take a Magdalene event and return its period number if avaliable.
        
        var returnArray = [HLLEvent]()
        
        if SchoolAnalyser.schoolMode != .Magdalene {
            return events
        }
        
        for event in events {
        
        var period: String?
            
        let formattedStart = event.startDate.formattedTimeTwelve()
        let formattedEnd = event.endDate.formattedTimeTwelve()
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: event.startDate)
            if let weekday = components.weekday {
                
                switch weekday {
                    
                case Weekday.Monday, Weekday.Wednesday, Weekday.Thursday, Weekday.Friday:
                    
                    // Monday, Wednesday, Thurday, Friday Periods
                    
                    switch (formattedStart, formattedEnd) {
                        
                    case ("8:15am", "9:30am"):
                        period = "1"
                        
                    case ("9:30am", "9:50am"):
                        period = "H"
                        
                    case ("9:50am", "10:05am"):
                        period = "R"
                        
                    case ("10:05am", "11:25am"):
                        period = "2"
                        
                    case ("10:10am", "11:25am"):
                        period = "2"
                        
                    case ("11:25am", "12:40pm"):
                        period = "3"
                        
                    case ("12:40pm", "1:15pm"):
                        period = "L"
                        
                    case ("1:15pm", "2:35pm"):
                        period = "4"
                        
                    case ("1:20pm", "2:35pm"):
                        period = "4"
                        
                    default:
                        period = nil
                        
                    }
                    
                case Weekday.Tuesday:
                    
                    // Tuesday Periods
                    
                    switch (formattedStart, formattedEnd) {
                        
                    case ("8:15am", "9:15am"):
                        period = "1"
                        
                    case ("9:15am", "10:15am"):
                        period = "2"
                        
                    case ("10:15am", "10:30am"):
                        period = "R"
                        
                    case ("10:30am", "11:25am"):
                        period = "H"
                        
                    case ("10:35am", "11:25am"):
                        period = "H"
                        
                    case ("11:25am", "12:25pm"):
                        period = "3"
                        
                    case ("12:25pm", "12:55pm"):
                        period = "L"
                        
                    case ("12:55pm", "2:35pm"):
                        period = "S"
                        
                    default:
                        period = nil
                        
                    }
                    
                default:
                    period = nil
                }
                
            }
        }
            
            
            var newEvent = event
            newEvent.period = period
            returnArray.append(newEvent)
                
            
            
        }
        
        return returnArray
        
    }
    
    
}
