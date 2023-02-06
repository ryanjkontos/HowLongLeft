//
//  UpcomingEventStringGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 1/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation



class UpcomingEventStringGenerator {
    
    func generateNextEventString(upcomingEvents: [HLLEvent]) -> String {
        
        var returnString = "No upcoming events"
        var starting = false
        
        if let first = upcomingEvents.first {
            
            var typeText = "next"
            
            if first.startDate.timeIntervalSince(CurrentDateFetcher.currentDate) > -2, first.startDate.timeIntervalSince(CurrentDateFetcher.currentDate) < 0 {
                
                starting = true
                typeText = "on now"
                
            }
            
            
            returnString = "\(first.title) is \(typeText)"
            
            var dateInfoEvent = first
            
            if first.title == "Lunch" || first.title == "Recess" {
                
                if upcomingEvents.indices.contains(1) {
                    
                    dateInfoEvent = upcomingEvents[1]
                    
                    returnString += ", then \(dateInfoEvent.title)"
                    
                }
                
            }
            
            if starting == false {
            
            if dateInfoEvent.startDate.startOfDay() == CurrentDateFetcher.currentDate.startOfDay() {
                
                returnString += ", at \(dateInfoEvent.startDate.formattedTime())."
                
            } else {
                
                returnString += ". (\(dateInfoEvent.startDate.userFriendlyRelativeString()), \(dateInfoEvent.startDate.formattedTime()))"
                
                
                
            }
                
            }
            
            if let location = dateInfoEvent.location {
                
                returnString += " (\(location))"
                
            }
            
        }
        
        return returnString
        
    }
    
    
    
    
}
